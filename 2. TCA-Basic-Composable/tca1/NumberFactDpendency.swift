//
//  NumberFactDpendency.swift
//  tca1
//
//  Created by Jeong Deokho on 2024/04/25.
//

import ComposableArchitecture
import Foundation

struct NumberFactDependency {
    var fetch: (Int) async throws -> String
}

extension NumberFactDependency: DependencyKey {
    static let liveValue = Self { number in
        let (data, _) = try await URLSession.shared
            .data(from: URL(string: "http://numbersapi.com/\(number)")!)
        return String(decoding: data, as: UTF8.self)
    }
}

extension DependencyValues {
    var 사실: NumberFactDependency {
        get { self[NumberFactDependency.self]}
        set { self[NumberFactDependency.self] = newValue}
    }
}
