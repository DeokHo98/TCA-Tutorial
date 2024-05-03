//
//  ChildView.swift
//  TCA-ChildView
//
//  Created by Jeong Deokho on 2024/04/25.
//

import SwiftUI
import ComposableArchitecture

struct ChildView: View {

    @Bindable var store: StoreOf<ChildFeature>

    var body: some View {
        NavigationStack {
            Form {
                TextField("입력", text: $store.text.sending(\.setText))
                Button("부모한테 전달") {
                    store.send(.deliveryButtonTap)
                }
            }
        }
    }
}
