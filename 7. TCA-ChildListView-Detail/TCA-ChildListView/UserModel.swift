//
//  User.swift
//  TCA-ChildListView
//
//  Created by Jeong Deokho on 2024/04/29.
//

import Foundation

struct UserModel: Equatable, Identifiable {
    let id: UUID
    var name = ""

    init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
}
