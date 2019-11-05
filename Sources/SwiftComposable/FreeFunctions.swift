//
//  FreeFunctions.swift
//
//
//  Created by Sasha Prokhorenko on 05.11.19.
//

public func combine<Value, Action>(
    _ reducers: Reducer<Value, Action>...
) -> Reducer<Value, Action> {
    { value, action in
        let effects = reducers.flatMap { $0(&value, action) }
        return effects
    }
}

public func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
    _ reducer: @escaping Reducer<LocalValue, LocalAction>,
    value: WritableKeyPath<GlobalValue, LocalValue>,
    action: WritableKeyPath<GlobalAction, LocalAction?>
) -> Reducer<GlobalValue, GlobalAction> {
    { globalValue, globalAction in
        guard let localAction = globalAction[keyPath: action] else { return [] }
        let localEffects = reducer(&globalValue[keyPath: value], localAction)

        return localEffects.map { localEffect in
            Effect { callback in
                localEffect.run { localAction in
                    var globalAction = globalAction
                    globalAction[keyPath: action] = localAction
                    callback(globalAction)
                }
            }
        }
    }
}

public func logging<Value, Action>(
    _ reducer: @escaping Reducer<Value, Action>
) -> Reducer<Value, Action> {
    { value, action in
        let effects = reducer(&value, action)
        let newValue = value
        return [Effect { _ in
            print("Action: \(action)")
            print("Value:")
            dump(newValue)
            print("---")
        }] + effects
    }
}
