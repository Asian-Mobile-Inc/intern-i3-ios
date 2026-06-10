//
//  TodoCellViewModel.swift
//  MVVM
//
//  Created by Văn Tiến on 21/05/2026.
//

import Foundation

class TodoCellViewModel {
    var name : String
    var isDone: Bool
    
    init(todo : Todo) {
        self.name = todo.name
        self.isDone = todo.isDone
    }
}
