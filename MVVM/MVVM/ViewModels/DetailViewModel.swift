//
//  DetailViewModel.swift
//  MVVM
//
//  Created by Văn Tiến on 22/05/2026.
//

import Foundation



class DetailViewModel {
    enum Output {
        case showTask(title: String, isDone: Bool)
        case didUpdatedTask(Todo)
        case didDeleteTask(Todo)
        case showError(String)
    }
    var onOutput : ((Output) -> Void)?
    
    var task : Todo
    
    init(task: Todo) {
        self.task = task
    }
    func viewDidLoad() {
        onOutput?(.showTask(title: task.name, isDone: task.isDone))
    }
    func updateTask(title: String?, description: String?) {
        let newTitle = title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !newTitle.isEmpty else {
            onOutput?(.showError("Title must not empty"))
            onOutput?(.showTask(title: task.name, isDone: task.isDone))
            return
        }

        task.name = newTitle

        onOutput?(.didUpdatedTask(task))
    }
    
    func deleteTask () {
        onOutput?(.didDeleteTask(task))
    }
}
