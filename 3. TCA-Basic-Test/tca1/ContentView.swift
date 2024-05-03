//
//  ContentView.swift
//  tca1
//
//  Created by Jeong Deokho on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    //뷰에 추가하는 첫번째는 구성한 리듀서를 사용하는 Store이다.
    //Store는 기능의 런타임을 나타낸다 즉 액션을 처리하여 상태를 업데이트할수있는 객체이며, 데이터를 제공한다.

    let store: StoreOf<CounterFeature>
    var body: some View {
        VStack {
            //바인딩할 State
            Text("\(store.카운트)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    //액션 호출
                    store.send(.빼기버튼클릭)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)

                Button("+") {
                    //액션 호출
                    store.send(.더하기버튼클릭)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            Button("사실") {
              store.send(.사실버튼클릭)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)

            Button("타이머 \(store.타이머작동중 ? "오프" : "온")") {
                store.send(.타이머버튼클릭)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)

            if store.로딩중 {
              ProgressView()
            } else if let fact = store.사실 {
              Text(fact)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
            }
        }
    }
}

#Preview {
    ContentView(
      store: Store(initialState: CounterFeature.State()) {
          //이렇게 주석을 달면 기능없이 디자인만 미리볼수 있다.
        // CounterFeature()
      }
    )
}
