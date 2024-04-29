//
//  ContentView.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/29.
//

import SwiftUI
import ComposableArchitecture

struct ListView: View {

    @Bindable var store: StoreOf<ListFeature>

    var body: some View {
        NavigationStack {
            ZStack {
                List(store.userModelList, id: \.id, rowContent: { model in
                    HStack {
                        Text(model.name)
                        Spacer()
                        Button("삭제") {
                            store.send(.deleteButtonTap(id: model.id))
                        }
                    }
                })
                if let addStore = store.scope(state: \.destinationState?.addFeature, action: \.destinationAction.addFeature) {
                    AddView(store: addStore)
                }
            }
            .navigationTitle("List").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("추가") {
                        store.send(.addButtonTap)
                    }
                }
            }
            .alert($store.scope(state: \.destinationState?.alert, action: \.destinationAction.alert))
        }
    }
}

#Preview {
    ListView(store: Store(initialState: ListFeature.State(userModelList: [
        .init(name: "가"),
        .init(name: "나"),
        .init(name: "다")
    ]), reducer: {
        ListFeature()
    }))
}
