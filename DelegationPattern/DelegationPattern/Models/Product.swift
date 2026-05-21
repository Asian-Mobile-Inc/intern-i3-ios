//
//  Product.swift
//  DelegationPattern
//
//  Created by Văn Tiến on 01/05/2026.
//

import Foundation

struct Product {
    let id : Int
    var name : String
    var price : Double
    var category : String
    var isFavorite : Bool
}

extension Product {
    static var sampleData : [Product] {
        return [
            Product(id: 1, name: "Iphone 15", price: 1500, category: "Phone", isFavorite: true),
            Product(id: 2, name: "Mac air m2", price: 5000, category: "Laptop", isFavorite: false),
            Product(id: 3, name: "AirPods Pro", price: 2000,  category: "Acessory", isFavorite: false),
            Product(id: 4, name: "iPad Air", price: 3000, category: "Tablet", isFavorite: false),
            Product(id: 5, name: "Apple Watch S9",price: 2000, category: "Acessory", isFavorite: true),
            
        ]
    }
}
