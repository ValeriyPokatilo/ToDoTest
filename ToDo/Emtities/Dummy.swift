//
//  File.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation
 
struct DummyData: Codable {
    let todos: [DummyTask]
}

struct DummyTask: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
