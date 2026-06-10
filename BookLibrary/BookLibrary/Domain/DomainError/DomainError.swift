//
//  DomainError.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation

enum SaveBookError : Error {
    case alreadyExists
}

extension SaveBookError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .alreadyExists:
            return "This book is already saved."
        }
    }
}
