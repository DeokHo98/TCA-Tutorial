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
        var pathState = StackState<DetailFeature.State>()
        var userModelList: IdentifiedArrayOf<UserModel> = []
    }

    enum Action {
        case addButtonTap
        case deleteButtonTap(id: UUID)
        case destinationAction(PresentationAction<Destination.Action>)
        case pathAction(StackAction<DetailFeature.State, DetailFeature.Action>)
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
            case .pathAction(.element(let id, let action)):
                if case .delegate(.confirmDeletion) = action {
                    guard let detailState = state.pathState[id: id] else { return .none }
                    state.userModelList.remove(id: detailState.model.id)
                }
            case .pathAction:
                return .none
            case .destinationAction:
                return .none
            }
            return .none
        }
        .ifLet(\.$destinationState, action: \.destinationAction)
        .forEach(\.pathState, action: \.pathAction) {
            DetailFeature()
        }

    }
}

// MARK: - Destination

extension ListFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case addFeature(AddFeature)
        case detailFeature(DetailFeature)
        case alert(AlertState<Alert>)
    }
}

// MARK: - Alert

extension ListFeature {
    enum Alert: Equatable {
        case confirmDelete(id: UUID)
    }
}

extension AlertState where Action == ListFeature.Alert {
  static func deleteConfirmation(id: UUID) -> Self {
      Self {
          TextState("삭제하시겠습니까?")
      } actions: {
          ButtonState(role: .destructive, action: .confirmDelete(id: id)) {
              TextState("삭제")
          }
          ButtonState(role: .cancel) {
              TextState("취소")
          }
      }
  }
}
