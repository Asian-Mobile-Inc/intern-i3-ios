//
//  TodoList.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import Foundation

struct Todo: Hashable {
    let id = UUID()
    var name: String
    var isDone: Bool
}

extension Todo {
    static func getTodoList() -> [[Todo]] {
        return [
            [
                Todo( name: "Buy groceries", isDone: true),
                Todo( name: "Pay electricity bill", isDone: true),
                Todo( name: "Morning coffee", isDone: false)
            ],
            [
                Todo( name: "Gym membership", isDone: false),
                Todo(name: "Book purchase", isDone: true),
                Todo( name: "Movie ticket", isDone: false),
                Todo( name: "Reading Book", isDone: true),
                Todo(name: "Listening Music", isDone: false)
            ],
            [
                Todo(name: "Learning English", isDone: false),
                Todo(name: "Reading Book", isDone: true),
                Todo(name: "Listening Music", isDone: false)
            ]
        ]
    }
}
