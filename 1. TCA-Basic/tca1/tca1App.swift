//
//  tca1App.swift
//  tca1
//
//  Created by Jeong Deokho on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct tca1App: App {

    static let store = Store(initialState: AppFeature.State()) {
      AppFeature()
    }

    var body: some Scene {
        WindowGroup {
          AppView(store: tca1App.store)
        }
    }
}
