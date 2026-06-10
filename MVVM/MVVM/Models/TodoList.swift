//
//  TodoList.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import Foundation

struct Todo: Hashable {
    var id: UUID = UUID()
    var name: String
    var isDone: Bool
    var section : Int = 0
}

extension Todo {
    static func getTodoList() -> [[Todo]] {
        return [
            [
                Todo( name: "Buy groceries", isDone: true, section: 0),
                Todo( name: "Pay electricity bill", isDone: true, section: 0),
                Todo( name: "Morning coffee", isDone: false, section: 0)
            ],
            [
                Todo( name: "Gym membership", isDone: false, section: 1),
                Todo(name: "Book purchase", isDone: true, section: 1),
                Todo( name: "Movie ticket", isDone: false, section: 1),
                Todo( name: "Reading Book", isDone: true),
                Todo(name: "Listening Music", isDone: false, section: 1)
            ],
            [
                Todo(name: "Learning English", isDone: false, section: 2),
                Todo(name: "Reading Book", isDone: true, section: 2),
                Todo(name: "Listening Music", isDone: false, section: 2)
            ]
        ]
    }
}

extension Todo {
    init(entity: TodoEntity) {
        self.id = entity.id ?? UUID()
        self.name = entity.title ?? ""
        self.isDone = entity.isDone
        self.section = Int(entity.section)
    }
}

extension TodoEntity {
    func update(from todo: Todo) {
        self.id = todo.id
        self.title = todo.name
        self.isDone = todo.isDone
        self.section = Int32(todo.section)
    }
}
