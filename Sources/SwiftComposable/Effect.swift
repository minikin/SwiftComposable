//
//  Effect.swift
//
//
//  Created by Sasha Prokhorenko on 05.11.19.
//

import Combine

public struct Effect<Output>: Publisher {
    public typealias Failure = Never

    let publisher: AnyPublisher<Output, Failure>

    public func receive<S>(
        subscriber: S
    ) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}

extension Effect {
    public static func fireAndForget(work: @escaping () -> Void) -> Effect {
        Deferred { () -> Empty<Output, Never> in
            work()
            return Empty(completeImmediately: true)
        }.eraseToEffect()
    }
}

extension Effect {
    static func async(
        work: @escaping (@escaping (Output) -> Void) -> Void
    ) -> Effect {
        Deferred {
            Future { callback in
                work { output in
                    callback(.success(output))
                }
            }
        }.eraseToEffect()
    }
}

extension Effect {
    public static func sync(work: @escaping () -> Output) -> Effect {
        Deferred {
            Just(work())
        }
        .eraseToEffect()
    }
}
