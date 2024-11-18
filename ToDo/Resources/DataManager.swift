//
//  DataManager.swift
//  ToDo
//
//  Created by Valeriy P on 18.11.2024.
//

import Foundation

final class DataManager {
    
    static let shared = DataManager()
    
    func getTasks() -> [ToDoItem] {
        return [
            ToDoItem(
                title: "Почитать книгу",
                description: "Почитать книгу Почитать книгу Почитать книгу Почитать книгу Почитать книгу Почитать книгу 98745 7897 7987 7777",
                date: "01/02/2003",
                completed: true),
            ToDoItem(
                title: "Генеральная уборка",
                description: "Генеральная уборка Генеральная уборка Генеральная уборка Генеральная уборка 123",
                date: "01/02/2003",
                completed: false),
            ToDoItem(
                title: "Тренировка",
                description: "Тренировка Тренировка Тренировка",
                date: "01/02/2003",
                completed: true)
        ]
    }
}
