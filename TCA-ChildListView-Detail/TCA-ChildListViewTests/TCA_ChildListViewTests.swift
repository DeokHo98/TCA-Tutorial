//
//  TCA_ChildListViewTests.swift
//  TCA-ChildListViewTests
//
//  Created by Jeong Deokho on 2024/04/29.
//

import XCTest
import ComposableArchitecture

@testable import TCA_ChildListView



final class TCA_ChildListViewTests: XCTestCase {

    var store: TestStore<ListFeature.State, ListFeature.Action>!

    override func setUpWithError() throws {
        store = TestStore(initialState: ListFeature.State()) {
            ListFeature()
        } withDependencies: {
            $0.uuid = .init {
                UUID(0)
            }
        }
    }

    override func tearDownWithError() throws {
        store = nil
    }

    func test_addFlow() async {
        let id = UUID(0)
        let name = "jeong"
        await store.send(.addButtonTap) {
            $0.destinationState = .addFeature(
                AddFeature.State(userModel: UserModel(id: id, name: ""))
            )
        }

        await store.send(\.destinationAction.addFeature.editingText, name) {
            $0.destinationState?.addFeature?.userModel.name = name
        }

        await store.send(\.destinationAction.addFeature.okButtonTap)

        await store.receive(\.destinationAction.addFeature.delegate.okButtonTap, timeout: 5) {
            $0.userModelList = [UserModel(id: id, name: name)]
            $0.destinationState = nil
        }
    }

    func test_addCancelFlow() async {
        let id = UUID(0)

        await store.send(.addButtonTap) {
            $0.destinationState = .addFeature(
                AddFeature.State(userModel: UserModel(id: id, name: ""))
            )
        }

        await store.send(\.destinationAction.addFeature.cancelButtonTap)

        await store.receive(\.destinationAction.addFeature.delegate.cancelButtonTap, timeout: 5) {
            $0.destinationState = nil
        }
    }

    func test_비포괄적테스트_한마디로_덜철저하게_테스트() async {
        store.exhaustivity = .off

        let name = "jeong"
        await store.send(.addButtonTap)
        await store.send(\.destinationAction.addFeature.editingText, name)
        await store.send(\.destinationAction.addFeature.okButtonTap)
        await store.skipReceivedActions()

        await store.assert { state in
            state.userModelList = [
                UserModel(id: UUID(0), name: name)
            ]
            state.destinationState = nil
        }
    }

    func test_delete_Alert() async {
        store = TestStore(initialState: ListFeature.State(userModelList: [
            .init(id: UUID(0), name: "jeong"),
            .init(id: UUID(1), name: "kim")
        ]), reducer: {
            ListFeature()
        })

        await store.send(.deleteButtonTap(id: UUID(1))) {
            $0.destinationState = .alert(.deleteConfirmation(id: UUID(1)))

        }

        await store.send(.destinationAction(.presented(.alert(.confirmDelete(id: UUID(1)))))) {
            $0.userModelList = [UserModel(id: UUID(0), name: "jeong")]
            $0.destinationState = nil
        }
    }

}
