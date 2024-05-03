//
//  tca1Tests.swift
//  tca1Tests
//
//  Created by Jeong Deokho on 2024/04/24.
//

import XCTest
import ComposableArchitecture

@testable import tca1


/*
 TCA에서 필요한 테스트중 유일한것은 리듀이며 이는 두가지 테스트로 귀결된다.
 액션이 이루어질때 상태가 어떻게 변경되는지, 그리고 이펙트가 실행되어 데이터를 리듀서에 다시 받아오는지
 TCA에선 간단한 어설션을 작성할수 있게 하고 깔끔한 실패메시지를 던지는 TestStore 객체가 있다.
 */

@MainActor
final class tca1Tests: XCTestCase {

    var store: TestStore<CounterFeature.State, CounterFeature.Action>!

    override func setUp() {
        self.store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    }

    func testCounter() async {
        //액션을 보내고
        await store.send(.더하기버튼클릭) {
            //상태를 체크 (다른값은 넣어보면 실패함)
            $0.카운트 = 1
        }
        await store.send(.빼기버튼클릭) {
            $0.카운트 = 0
        }
    }


    /*
     위에는 리듀서의 가장 중요한 책임 한개를 테스트해봤다.
     다음 책임은 반환된 이펙트를 확인해보는것이다.
     이러한테스트는 테스트 친화적인 코드로 의존성주입을 통해 보통 이루어진다.
     */
    func testTimer() async {
        await store.send(.타이머버튼클릭) {
            $0.타이머작동중 = true
        }

        //receive는 비동기적으로 동작하는 어떤 액션에대한 상태 응답을 유도하는지 확인하는데 쓰인다.
        await store.receive(\.타이머틱, timeout: .seconds(5)) {
            $0.카운트 = 1
        }

        await store.send(.타이머버튼클릭) {
            $0.타이머작동중 = false
        }
    }

    func testFact() async {
        self.store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.사실.fetch = { "\($0) number" }
        }

        await store.send(.사실버튼클릭) {
            $0.로딩중 = true
        }

        await store.receive(\.사실응답, timeout: .seconds(5)) {
            $0.로딩중 = false
            $0.사실 = "\($0.카운트) number"
        }
    }
}
