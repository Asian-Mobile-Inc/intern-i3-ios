//
//  BookSearchResponse.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import Foundation

struct BookSearchResponse : Decodable {
    var docs : [BookDTO]
}
