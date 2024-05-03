//
//  AppFeatureTest.swift
//  AppFeatureTest
//
//  Created by Jeong Deokho on 2024/04/25.
//

import ComposableArchitecture
import XCTest
@testable import tca1

@MainActor
final class AppFeatureTests: XCTestCase {

  func testIncrementInFirstTab() async {
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }

      await store.send(\.tab1.더하기버튼클릭) {
          $0.tab1.카운트 = 1
      }

      await store.send(\.tab2.더하기버튼클릭) {
          $0.tab2.카운트 = 1
      }
  }

}
