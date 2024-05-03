//
//  tca1App.swift
//  tca1
//
//  Created by Jeong Deokho on 2024/04/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct tca1App: App {
    var body: some Scene {
        WindowGroup {
            //스토어는 앱을 구동하는동안 딱한번 생성되어야 한다는것을 꼭 주의해야한다.
            let store = Store(initialState: CounterFeature.State()) {
                CounterFeature()
                //리듀서에서 호출할 애플리케이션의 진입점을 업데이트해 print해주는 메서드 ._printChanges(_:)
                    ._printChanges()
            }
            ContentView(store: store)
        }
    }
}
