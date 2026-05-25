//
//  TodoListViewModel.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import Foundation

enum TaskListState {
    case idle
    case loading
    case loaded([[Todo]])
    case empty
    case error(String)
}

class TodoListViewModel {
    var todoList: [[Todo]] = []
    let state = Observable<TaskListState>(.idle)
    
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
            state.value = .loading

            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                let result = Todo.getTodoList()

                DispatchQueue.main.async {
                    self.todoList = result

                    if result.isEmpty {
                        self.state.value = .empty
                    } else {
                        self.state.value = .loaded(result)
                    }
                }
            }
        }
    
    public func addTask(section: Int, name: String, isDone: Bool = false ) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            state.value = .error("Title must not empty!!")
            return
        }
        
        let newTask = Todo(name: name, isDone: isDone)
        todoList[section].append(newTask)
        state.value = .loaded(todoList)
    }
    
    func updateTask(_ updatedTask: Todo, section: Int, itemIndex: Int) {
        guard let index = todoList[section].firstIndex(where: { $0.id == updatedTask.id }) else {
            state.value = .error("Not found task to update")
            return
        }

        todoList[section][index] = updatedTask
        state.value = .loaded(todoList)
        }
    
    func removeTask(_ deletedTask: Todo, section: Int, index: Int) {
//        guard todoList[section].indices.contains(index) else {
//            onOutput?(.error("This item isn't exist"))
//            return
//        }
        
        guard let index = todoList[section].firstIndex(where: { $0.id == deletedTask.id }) else {
            state.value = .error("Not found task to delete")
            return
        }
        
        todoList[section].remove(at: index)
        state.value = .loaded(todoList)
    }
   
}
