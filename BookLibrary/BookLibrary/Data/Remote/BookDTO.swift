//
//  BookDTO.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation

struct BookDTO : Decodable {
    let key: String?
    let title: String?
    let authorName: [String]?
    let firstPublishYear: Int?
    let coverID: Int?
    
    enum CodingKeys: String, CodingKey {
        case key
        case title
        case authorName = "author_name"
        case firstPublishYear = "first_publish_year"
        case coverID = "cover_i"
    }
}

extension BookDTO {
    func toBook() -> Book? {
        guard let title, let key else {
            return nil
        }
        
        return Book(
            id: key,
            title: title,
            author: authorName?.joined(separator: ", ") ?? "Unknown Author",
            firstPublishYear: firstPublishYear,
            coverID: coverID)
    }
}
