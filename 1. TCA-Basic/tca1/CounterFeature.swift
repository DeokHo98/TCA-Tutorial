//
//  CounterFeature.swift
//  tca1
//
//  Created by Jeong Deokho on 2024/04/24.
//

import ComposableArchitecture
import Foundation

/*
 TCA에서 기능의 기본단위는 리듀서임
 리듀서는 Action이 입력되면 State를 변경하는 방법과 네트워크 통신과 같은 외부와의 상호작용후에 데이터를 공급하는 방법을 포함한다.

TCA를 사용하는 주요 이점중 하나는 특정UI프레임워크와 상관없이 기능의 핵심 로직과 동작을 격리할수있다는것이다.
 이는 기능을 독립적으로 개발하고 테스트할수 있음을 의미한다.
 */

@Reducer
struct CounterFeature {

    //작업을 수행하는데 필요한 상태를 보유하는 유형
    @ObservableState
    struct State: Equatable {
        var 카운트 = 0
        var 로딩중 = false
        var 타이머작동중 = false
        var 사실: String?
    }


    //사용자가 수행할수 있는 기능을 보유하는 유형 일반적으로는 열거형
    enum Action {
        //Input
        case 더하기버튼클릭
        case 빼기버튼클릭
        case 사실버튼클릭
        case 타이머버튼클릭

        //Output
        case 타이머틱
        case 사실응답(String)
        case 에러응답(String)
    }

    enum CancelID {
        case timer
    }

    //여기서 사용자 액션에 따라 상태를 현재값에서 다음값으로 진화시키고 외부와의 상호작용을 해야한다.
    //이는 들어오는 액션을 기반으로 어떤로직을 수행해야하는지를 결정하기위해 Switch 문을 사용하며 상태는 inout으로 제공되며 직접 변경할 수 있다.
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .더하기버튼클릭:
                state.카운트 += 1
                state.사실 = nil
                return .cancel(id: CancelID.timer)
            case .빼기버튼클릭:
                state.카운트 -= 1
                state.사실 = nil
                return .cancel(id: CancelID.timer)
            case .사실버튼클릭:
                state.사실 = nil
                state.로딩중 = true
                //비동기적인 흐름의 코드를 작성할때는 .run을 이용해야함.
                return .run { [state] send in
                    do {
                        let (데이터, _) = try await URLSession.shared
                            .data(from: URL(string: "http://numbersapi.com/\(state.카운트)")!)
                        let 사실 = String(decoding: 데이터, as: UTF8.self)
                        await send(.사실응답(사실))
                    } catch let 에러 {
                        await send(.에러응답(에러.localizedDescription))
                    }
                }
            case .타이머버튼클릭:
                state.타이머작동중.toggle()
                state.사실 = nil
                guard state.타이머작동중 else { return .cancel(id: CancelID.timer) }
                // return .cancel은 이펙트를 취소한다. 취소할 이벡트의 식별자를 전달해야한다.
                return .run { send in
                    while true {
                        try await Task.sleep(for: .seconds(1))
                        await send(.타이머틱)
                    }
                }
                //이벤트를 취소 가능하게 만든다 쉽게말해
                //.cancel로 취소한 식별자랑 같다면 여기 run 작업이 취소되는것이다.                .cancellable(id: CancelID.timer)
            case .사실응답(let 사실):
                state.사실 = 사실
                state.로딩중 = false
            case .에러응답(let 에러):
                state.사실 = 에러
                state.로딩중 = false
            case .타이머틱:
                state.카운트 += 1
            }
            return .none
        }
    }
}
