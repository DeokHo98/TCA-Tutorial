//
//  AddView.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/29.
//

import SwiftUI
import ComposableArchitecture

struct AddView: View {

   @Bindable var store: StoreOf<AddFeature>

    var body: some View {
        VStack {
            TextField("닉네임 입력", text: $store.userModel.name.sending(\.editingText))
                .frame(width: 200)
                .textFieldStyle(.roundedBorder)
            HStack(spacing: 0) {
                Button("취소") {
                    store.send(.cancelButtonTap)
                }
                .font(.headline)
                .foregroundStyle(.red)
                .frame(width: 100)

                Button("확인") {
                    store.send(.okButtonTap)
                }
                .font(.headline)
                .frame(width: 100)
            }
            .frame(width: 200)
        }
        .frame(width: 220, height: 100)
        .background(Color(uiColor: .systemGray4))
        .clipShape(.rect(cornerRadius: 10))


    }
}
