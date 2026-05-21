//
//  Task.swift
//  CollectionView
//
//  Created by Văn Tiến on 15/05/2026.
//

import Foundation

struct TodoList {
    var taskTypes : [TaskTypes]
}

struct TaskTypes {
    let type : String
    var Tasks: [Task]
}

struct Task {
    var title : String
    var description : String
    var schedule : Date?
}

extension TodoList {
    static func getSampleData() -> TodoList {
        TodoList(
            taskTypes:
                [TaskTypes(
                    type: "Category",
                    Tasks:
                        [
                            Task(title: "Office", description: "Office Description"),
                            Task(title: "Persional", description: "Persional Description"),
                            Task(title: "Daily", description: "Daily Description"),
                            Task(title: "Others", description: "Others Description")
                        ],
                    ),
                 TaskTypes(
                     type: "Schedule",
                     Tasks:
                         [
                             Task(title: "Schedule Task 1", description: "Schedule Task 1 Description"),
                             Task(title: "Schedule Task 2", description: "Schedule Task 2 Description"),
                             Task(title: "Schedule Task 3", description: "Schedule Task 3 Description"),
                             Task(title: "Schedule Task 4", description: "Schedule Task 4 Description")
                         ],
                     ),
                 TaskTypes(
                     type: "Ongoing Tasks",
                     Tasks:
                         [
                             Task(title: "Ongoing Tasks 1", description: "Ongoing Tasks 1 Description"),
                             Task(title: "Ongoing Tasks 2", description: "Ongoing Tasks 2 Description"),
                             Task(title: "Ongoing Tasks 3", description: "Ongoing Tasks 3 Description"),
                             Task(title: "Ongoing Tasks 4", description: "Ongoing Tasks 4 Description")
                         ],
                     )
                ]
            )
    }
}
