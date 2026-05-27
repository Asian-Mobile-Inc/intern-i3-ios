//
//  TodoListViewModel.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import Foundation
import Combine

class TodoListViewModel {
    @Published private(set) var todoList: [[Todo]] = []
    @Published private(set) var errorMessage : String? = nil
    
    var numberOfSections : Int {
        todoList.count
    }
    func numberOfIemsInSection(at section: Int) -> Int {
        todoList[section].count
    }
    
    func itemAt (section: Int, item: Int) -> TodoCellViewModel {
        TodoCellViewModel(todo: todoList[section][item])
    }
    
    func loadTasks() {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                let result = Todo.getTodoList()

                DispatchQueue.main.async {
                    self.todoList = result

                    if result.isEmpty {
                        self.errorMessage = "Data is empty"
                    } else {
                        self.todoList = result
                    }
                }
            }
        }
    
    public func addTask(section: Int, name: String, isDone: Bool = false ) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Title must not empty!!"
            return
        }
        
        let newTask = Todo(name: name, isDone: isDone)
        todoList[section].append(newTask)
    }
    
    func updateTask(_ updatedTask: Todo, section: Int, itemIndex: Int) {
        guard let index = todoList[section].firstIndex(where: { $0.id == updatedTask.id }) else {
            errorMessage = "Not found task to update"
            return
        }

        todoList[section][index] = updatedTask
        }
    
    func removeTask(_ deletedTask: Todo, section: Int, index: Int) {
//        guard todoList[section].indices.contains(index) else {
//            onOutput?(.error("This item isn't exist"))
//            return
//        }
        
        guard let index = todoList[section].firstIndex(where: { $0.id == deletedTask.id }) else {
            errorMessage = "Not found task to delete"
            return
        }
        
        todoList[section].remove(at: index)    }
   
}
