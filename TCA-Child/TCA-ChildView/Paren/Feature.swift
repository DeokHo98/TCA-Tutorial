//
//  Feature.swift
//  TCA-ChildView
//
//  Created by Jeong Deokho on 2024/04/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        @Presents var childState: ChildFeature.State?
        var text = ""
    }

    enum Action {
        case moveChildButtonTap
        case childAction(PresentationAction<ChildFeature.Action>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .moveChildButtonTap:
                return .none
            case .childAction:
                return .none
            }
            return .none
        }
    }
}
