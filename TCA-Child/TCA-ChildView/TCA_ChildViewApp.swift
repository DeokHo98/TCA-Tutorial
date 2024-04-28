//
//  TCA_ChildViewApp.swift
//  TCA-ChildView
//
//  Created by Jeong Deokho on 2024/04/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_ChildViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: .init(initialState: Feature.State(), reducer: {
                Feature()
            }))
        }
    }
}
