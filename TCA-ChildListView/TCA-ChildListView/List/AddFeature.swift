//
//  AddFeature.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/29.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddFeature {
    @ObservableState
    struct State: Equatable {
        var userModel: UserModel = UserModel()
    }

    enum Action {
        case editingText(String)
        case cancelButtonTap
        case okButtonTap
        case delegate(Delegate)

        enum Delegate {
            case cancelButtonTap
            case okButtonTap(UserModel)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editingText(let text):
                state.userModel = .init(name: text)
            case .cancelButtonTap:
                return .run { send in
                    await send(.delegate(.cancelButtonTap))
                }
            case .okButtonTap:
                return .run { [state] send in
                    await send(.delegate(.okButtonTap(state.userModel)))
                }
            case .delegate:
                return .none
            }
            return .none
        }
    }
}
