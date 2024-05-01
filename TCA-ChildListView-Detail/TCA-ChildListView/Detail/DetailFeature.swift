//
//  DetailFeature.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/30.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DetailFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destinationState: Destination.State?
        let model: UserModel
    }

    enum Action {
        case deleteButtonTap
        case destinationAction(PresentationAction<Destination.Action>)
        case delegate(Delegate)
    }

    @Dependency(\.dismiss) var dismiss
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deleteButtonTap:
                state.destinationState = .alert(.deleteConfirmation(id: state.model.id))
            case .destinationAction(.presented(.alert(.confirmDelete))):
                return .run { send in
                    await send(.delegate(.confirmDeletion))
                    await self.dismiss()
                }
            case .destinationAction:
                return .none
            case .delegate:
                return .none
            }
            return .none
        }
        .ifLet(\.$destinationState, action: \.destinationAction)
    }
}

// MARK: - Destination

extension DetailFeature {
    @Reducer(state: .equatable)
    enum Destination {
        case alert(AlertState<Alert>)
    }
}

// MARK: - Alert

extension DetailFeature {
    enum Alert: Equatable {
        case confirmDelete
    }
}

// MARK: - DetailFeature

extension DetailFeature {
    enum Delegate {
        case confirmDeletion
    }
}

extension AlertState where Action == DetailFeature.Alert {
  static func deleteConfirmation(id: UUID) -> Self {
      Self {
          TextState("삭제하시겠습니까?")
      } actions: {
          ButtonState(role: .destructive, action: .confirmDelete) {
              TextState("삭제")
          }
          ButtonState(role: .cancel) {
              TextState("취소")
          }
      }
  }
}
