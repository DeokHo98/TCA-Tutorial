//
//  ChildFeature.swift
//  TCA-ChildView
//
//  Created by Jeong Deokho on 2024/04/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ChildFeature {
    @ObservableState
    struct State: Equatable {
        var text = ""
    }

    enum Action {
        case deliveryButtonTap
        case setText(String)
        case delegate(Delegate)

        enum Delegate: Equatable {
            case saveText(String)
        }
    }

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deliveryButtonTap:
                return .run { [state] send in
                    await send(.delegate(.saveText(state.text)))
                    await self.dismiss()
                }
            case .setText(let text):
                state.text = text
            case .delegate:
                return .none
            }
            return .none
        }
    }
}
