//
//  AppView.swift
//  tca1
//
//  Created by Jeong Deokho on 2024/04/25.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    /*
     이렇게 다수의 완전히 격리된 Store를 가지는것은 이상적이지 않다.
     앞으로는 한탭에서 발생하는 이벤트가 다른탭에 영향을 끼치는 상황이 아주많을텐데
     TCA에서는 Feature들을 함께 조합(compose) 하고 단일 Store를 기반으로 하는것을 선호한다.
     이렇게하면 Feature들이 서로 통신할수있게되어 훨씬 편리해지며 서로간의 통신이 올바른지 테스트하는것도 가능하다.
     */
    let store: StoreOf<AppFeature>

    var body: some View {
        Text("\(store.상태)")
        TabView {
            ContentView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("Counter 1")
                }

            ContentView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Counter 2")
                }
        }
    }
}
