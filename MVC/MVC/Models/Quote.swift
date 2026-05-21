//
//  Quote.swift
//  MVC
//
//  Created by Văn Tiến on 12/05/2026.
//

import Foundation

struct Quote: Codable {
    let id: Int
    let quote: String
    let author: String
    var isSelected: Bool = Bool.random()
    
    enum CodingKeys: String, CodingKey {
        case id
        case quote
        case author
    }
}

struct QuoteResponse: Codable {
    let quotes: [Quote]
    let total: Int
    let skip: Int
    let limit: Int
}
