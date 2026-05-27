//
//  DetailViewModel.swift
//  MVVM
//
//  Created by Văn Tiến on 22/05/2026.
//

import Foundation
import Combine

class DetailViewModel {

    @Published private(set) var task : Todo
    private(set) var didDeleteTask = PassthroughSubject<Todo, Never>()
    private(set) var showError = PassthroughSubject<String, Never>()
    
    init(task: Todo) {
        self.task = task
    }

    func updateTask(title: String?, description: String?) {
        let newTitle = title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        let newDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !newTitle.isEmpty else {
            showError.send("Title must not empty!")
            return
        }

        task.name = newTitle
    }
    
    func deleteTask () {
        didDeleteTask.send(task)
    }
}
