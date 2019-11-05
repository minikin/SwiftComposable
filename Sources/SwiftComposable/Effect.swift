//
//  Effect.swift
//
//
//  Created by Sasha Prokhorenko on 05.11.19.
//

import Combine
import SwiftUI

public struct Effect<A> {
    public let run: (@escaping (A) -> Void) -> Void

    public init(run: @escaping (@escaping (A) -> Void) -> Void) {
        self.run = run
    }

    public func map<B>(_ f: @escaping (A) -> B) -> Effect<B> {
        Effect<B> { callback in self.run { a in callback(f(a)) } }
    }
}

extension Effect where A == (Data?, URLResponse?, Error?) {
    public func decode<M: Decodable>(as _: M.Type) -> Effect<M?> {
        map { data, _, _ in
            data
                .flatMap { try? JSONDecoder().decode(M.self, from: $0) }
        }
    }
}

extension Effect {
    public func receive(on queue: DispatchQueue) -> Effect {
        Effect { callback in
            self.run { a in
                queue.async {
                    callback(a)
                }
            }
        }
    }
}
