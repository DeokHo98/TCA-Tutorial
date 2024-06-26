//
//  ListFeature.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/29.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ListFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destinationState: Destination.State?
        var userModelList: IdentifiedArrayOf<UserModel> = []
    }

    enum Action {
        case addButtonTap
        case deleteButtonTap(id: UUID)
        case destinationAction(PresentationAction<Destination.Action>)

        enum Alert: Equatable {
            case confirmDelete(id: UUID)
        }
    }

    @Dependency(\.uuid) var uuid
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTap:
                state.destinationState = .addFeature(AddFeature.State(userModel: UserModel(id: uuid(), name: "")))
            case .destinationAction(.presented(.addFeature(.delegate(.okButtonTap(let userModel))))):
                state.userModelList.append(userModel)
                state.destinationState = nil
            case .destinationAction(.presented(.addFeature(.delegate(.cancelButtonTap)))):
                state.destinationState = nil
            case .destinationAction(.presented(.alert(.confirmDelete(let id)))):
                state.userModelList.remove(id: id)
            case .deleteButtonTap(let id):
                state.destinationState = .alert(.deleteConfirmation(id: id))
            case .destinationAction:
                return .none
            }
            return .none
        }
        .ifLet(\.$destinationState, action: \.destinationAction)
    }
}

extension ListFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case addFeature(AddFeature)
        case alert(AlertState<ListFeature.Action.Alert>)
    }
}

extension AlertState where Action == ListFeature.Action.Alert {
  static func deleteConfirmation(id: UUID) -> Self {
      Self {
          TextState("삭제하시겠습니까?")
      } actions: {
          ButtonState(role: .destructive, action: .confirmDelete(id: UUID(1))) {
              TextState("삭제")
          }
          ButtonState(role: .cancel) {
              TextState("취소")
          }
      }
  }
}
