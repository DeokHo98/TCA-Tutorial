//
//  AppFeature.swift
//  tca1
//
//  Created by Jeong Deokho on 2024/04/25.
//

import ComposableArchitecture

/*
 위에서 생성한 AppView의 로직과 동작을 구동하기 위해 새로운 앱 레벨의 리듀서를 만들 것이다.
 또한, CounterFeature 및 CounterView와 마찬가지로 리듀서를 동일한 파일에 넣을 것이다.
 우리는 피처가 너무 커질 때까지 이를 선호한다. 그런 다음 리듀서와 뷰를 각각의 파일로 분할할 것이다.
 */

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
        var 상태: String = ""
    }

    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }


    var body: some ReducerOf<Self> {
        /*
         CounterFeature를 AppFeature에 통합하기위해 Scope 리듀서를 사용한다.
         이 리듀서는 부모기능의 하위 도메인에 집중하고 해당 하위 도메인에서 자식 리듀서를 실행할수 있다.
         */
        Scope(state: \.tab1, action: \.tab1) {
          CounterFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
          CounterFeature()
        }
        Reduce { state, action in
            switch action {
            case .tab1(let action):
                if case CounterFeature.Action.더하기버튼클릭 = action {
                    state.상태 = "1번째 탭에서 더하기 버튼이 클릭"
                }
            case .tab2(let action):
                if case CounterFeature.Action.더하기버튼클릭 = action {
                    state.상태 = "2번째 탭에서 더하기 버튼이 클릭"
                }
            }
            return .none
        }
    }

}
