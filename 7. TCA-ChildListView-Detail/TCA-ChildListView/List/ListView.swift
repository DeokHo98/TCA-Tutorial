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
        NavigationStack(path: $store.scope(state: \.pathState, action: \.pathAction)) {
            ZStack {
                List(store.userModelList, id: \.id, rowContent: { model in
                    NavigationLink(state: DetailFeature.State(model: model)) {
                        HStack {
                            Text(model.name)
                            Spacer()
                            Button {
                                store.send(.deleteButtonTap(id: model.id))
                            } label: {
                                Text("삭제")
                            }

                        }
                    }
                    .buttonStyle(.borderless)
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
        } destination: { store in
            DetailView(store: store)
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
