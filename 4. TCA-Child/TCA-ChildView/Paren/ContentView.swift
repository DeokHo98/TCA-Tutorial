//
//  ContentView.swift
//  TCA-ChildView
//
//  Created by Jeong Deokho on 2024/04/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {

    @Bindable var store: StoreOf<Feature>

    var body: some View {
        NavigationStack {
            VStack {
                Text(store.text)
                    .toolbar {
                        ToolbarItem {
                            Button {
                                store.send(.moveChildButtonTap)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .navigationDestination(item: $store.scope(state: \.childState, action: \.childAction)) { store in
                        ChildView(store: store)
                    }
            }
        }
    }
}


