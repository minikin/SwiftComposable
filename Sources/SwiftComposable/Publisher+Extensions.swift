//
//  Publisher+Extensions.swift
//
//
//  Created by Sasha Prokhorenko on 19.11.19.
//

import Combine

extension Publisher where Failure == Never {
    public func eraseToEffect() -> Effect<Output> {
        Effect(publisher: eraseToAnyPublisher())
    }
}
