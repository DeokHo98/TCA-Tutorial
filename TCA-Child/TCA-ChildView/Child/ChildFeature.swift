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
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deliveryButtonTap:
                return .none
            case .setText(let text):
                state.text = text
            }
            return .none
        }
    }
}

struct Contact: Equatable, Identifiable {
  let id: UUID
  var name: String
}


@Reducer
struct ContactsFeature {
  @ObservableState
  struct State: Equatable {
    @Presents var addContact: AddContactFeature.State?
    var contacts: IdentifiedArrayOf<Contact> = []
  }
  enum Action {
    case addButtonTapped
    case addContact(PresentationAction<AddContactFeature.Action>)
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.addContact = AddContactFeature.State(
          contact: Contact(id: UUID(), name: "")
        )
        return .none

      case .addContact(.presented(.cancelButtonTapped)):
        state.addContact = nil
        return .none

      case .addContact(.presented(.saveButtonTapped)):
        guard let contact = state.addContact?.contact
        else { return .none }
        state.contacts.append(contact)
        state.addContact = nil
        return .none

      case .addContact:
        return .none
      }
    }
    .ifLet(\.$addContact, action: \.addContact) {
      AddContactFeature()
    }
  }
}

@Reducer
struct AddContactFeature {
  @ObservableState
  struct State: Equatable {
      var contact: Contact = .init(id: .init(), name: "")
  }
  enum Action {
    case cancelButtonTapped
    case saveButtonTapped
    case setName(String)
  }
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .cancelButtonTapped:
        return .none

      case .saveButtonTapped:
        return .none

      case let .setName(name):
        state.contact.name = name
        return .none
      }
    }
  }
}
