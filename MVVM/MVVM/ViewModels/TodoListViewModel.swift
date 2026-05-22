//
//  TodoListViewModel.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import Foundation

enum TodoListState {
    case reloadData
    case error(String)
}

class TodoListViewModel {
    private var todoList : [[Todo]] = Todo.getTodoList()
    var onOutput: ((TodoListState) -> Void)?
    
    var numberOfSections : Int {
        todoList.count
    }
    func numberOfIemsInSection(at section: Int) -> Int {
        todoList[section].count
    }
    
    func itemAt (section: Int, item: Int) -> TodoCellViewModel {
        TodoCellViewModel(todo: todoList[section][item])
    }
    
    func addTask(section: Int, name: String, isDone: Bool = false ) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onOutput?(.error("Title must not empty!!"))
            return
        }
        
        let newTask = Todo(name: name, isDone: isDone)
        todoList[section].append(newTask)
        onOutput?(.reloadData)
    }
    
    func removeTask(section: Int, index: Int) {
        guard todoList[section].indices.contains(index) else {
            onOutput?(.error("This item isn't exist"))
            return
        }
        todoList[section].remove(at: index)
        onOutput?(.reloadData)
    }
   
}
