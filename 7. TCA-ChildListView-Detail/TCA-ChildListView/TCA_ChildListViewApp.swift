//
//  TCA_ChildListViewApp.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/29.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_ChildListViewApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(store: Store(initialState: ListFeature.State(), reducer: {
                ListFeature()
                    ._printChanges()
            }))
        }
    }
}
