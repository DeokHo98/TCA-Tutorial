//
//  DetailView.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/30.
//

import SwiftUI
import ComposableArchitecture

struct DetailView: View {

   @Bindable var store: StoreOf<DetailFeature>

    var body: some View {
        Button("삭제") {
            store.send(.deleteButtonTap)
        }
        .navigationTitle("Detail").navigationBarTitleDisplayMode(.inline)
        .alert($store.scope(state: \.destinationState?.alert, action: \.destinationAction.alert))
    }

}

#Preview {
    DetailView(store: .init(initialState: DetailFeature.State(model: .init()), reducer: {
        DetailFeature()
    }))
}
