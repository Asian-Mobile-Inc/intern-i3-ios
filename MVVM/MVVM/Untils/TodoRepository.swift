//
//  TodoRepository.swift
//  MVVM
//
//  Created by Văn Tiến on 29/05/2026.
//

import Foundation
import CoreData
import UIKit

class TodoRepository {
    private var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func setMockDataIfNeeded() {
        let request : NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            
            if count > 0 {
                return
            }
            
            let mockTodos = Todo.getTodoList()
            for sections in mockTodos {
                for item in sections {
                    let todo = TodoEntity(context: context)
                    todo.title = item.name
                    todo.id = item.id
                    todo.isDone = item.isDone
                    todo.section = Int32(item.section)
                    
                }
            }
            
            
            try context.save()
            
        } catch {
            print("Error", error)
        }
    }
    //MARK: FETCH TODO
    func fetchTodo(filterType: TodoFilterType = .all, sortType: TodoSortType = .titleAZ) -> [[Todo]]{
        setMockDataIfNeeded()
        let request : NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        
        switch filterType {
        case .all:
            request.predicate = nil
        case .active:
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: false))
        case .completed:
            request.predicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        }
        
        switch sortType {
            
        case .titleAZ:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        case .titleZA:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        }
        var arrayTodo: [[Todo]] = []
        
        do {
            let entities = try context.fetch(request)
            let todos = entities.map { Todo(entity: $0) }
            
            for item in todos {
                let section = item.section
                while arrayTodo.count <= section {
                    arrayTodo.append([])
                }
                arrayTodo[section].append(item)
            }
            
        } catch {
            print("Fetch Failed", error)
        }
        
        return arrayTodo
    }
    
    
    //MARK: CRUD
    func addTask(title: String, section: Int) {
        let entity = TodoEntity(context: context)
        entity.title = title
        entity.section = Int32(section)
        entity.isDone = false
        entity.id = UUID()
        
        save()
        
    }
    
    func updateTask(_ todo : Todo) {
        let request : NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", todo.id as CVarArg)

        do {
            let entities = try context.fetch(request)
            let entity = entities.first

            entity?.update(from: todo)

            save()
            
        } catch {
            print("Update todo failed:", error)
        }
    }
    private func save() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch {
            print("Save context failed:", error)
        }
    }
}
