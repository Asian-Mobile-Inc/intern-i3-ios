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
    var todoList : [[Todo]] = Todo.getTodoList()
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
    
    public func addTask(section: Int, name: String, isDone: Bool = false ) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            onOutput?(.error("Title must not empty!!"))
            return
        }
        
        let newTask = Todo(name: name, isDone: isDone)
        todoList[section].append(newTask)
        onOutput?(.reloadData)
    }
    
    func updateTask(_ updatedTask: Todo, section: Int, itemIndex: Int) {
        guard let index = todoList[section].firstIndex(where: { $0.id == updatedTask.id }) else {
            onOutput?(.error("Not found task to update"))
            return
        }

        todoList[section][index] = updatedTask
        onOutput?(.reloadData)
        }
    
    func removeTask(_ deletedTask: Todo, section: Int, index: Int) {
//        guard todoList[section].indices.contains(index) else {
//            onOutput?(.error("This item isn't exist"))
//            return
//        }
        
        guard let index = todoList[section].firstIndex(where: { $0.id == deletedTask.id }) else {
            onOutput?(.error("Not found task to delete"))
            return
        }
        
        todoList[section].remove(at: index)
        onOutput?(.reloadData)
    }
   
}
