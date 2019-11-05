//
//  URLSession+Effect.swift
//
//
//  Created by Developer on 05.11.19.
//

import Foundation

extension URLSession {
    public func dataTask(with url: URL) -> Effect<(Data?, URLResponse?, Error?)> {
        Effect { callback in
            URLSession.shared.dataTask(with: url) { data, response, error in
                callback((data, response, error))
            }
            .resume()
        }
    }
}
