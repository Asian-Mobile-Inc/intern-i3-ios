//
//  Product.swift
//  TabbarVC
//
//  Created by Văn Tiến on 20/05/2026.
//

import Foundation

struct Product {
    var title : String
    var items : [Item]
}

struct Item: Hashable {
       let id: Int
       let itemTitle: String
       let description: String

       func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }

       static func == (lhs: Item, rhs: Item) -> Bool {
           lhs.id == rhs.id
       }
}

extension Product {
    static func mockData() -> [Product] {
        return [
            Product(title: "Electronics", items: [
                Item(id: 1, itemTitle: "iPhone 15", description: "Latest Apple smartphone with A16 Bionic chip."),
                Item(id: 2, itemTitle: "MacBook Pro", description: "Powerful laptop for professionals."),
                Item(id: 3, itemTitle: "AirPods Pro", description: "Noise-cancelling wireless earbuds.")
            ]),
            Product(title: "Clothing", items: [
                Item(id: 4, itemTitle: "Basic T-Shirt", description: "100% cotton comfortable t-shirt."),
                Item(id: 5, itemTitle: "Denim Jeans", description: "Classic blue jeans with regular fit."),
                Item(id: 6, itemTitle: "Sneakers", description: "Running shoes with breathable mesh."),
                Item(id: 7, itemTitle: "Basic T-Shirt", description: "100% cotton comfortable t-shirt."),
                Item(id: 8, itemTitle: "Denim Jeans", description: "Classic blue jeans with regular fit."),
                Item(id: 9, itemTitle: "Sneakers", description: "Running shoes with breathable mesh.")
            ]),
            Product(title: "Home & Kitchen", items: [
                Item(id: 10, itemTitle: "Coffee Maker", description: "Programmable coffee machine with glass carafe."),
                Item(id: 11, itemTitle: "Blender", description: "High-speed blender for smoothies and shakes."),
                Item(id: 12, itemTitle: "Microwave Oven", description: "Compact microwave with multiple presets."),
                Item(id: 13, itemTitle: "Coffee Maker", description: "Programmable coffee machine with glass carafe."),
                Item(id: 14, itemTitle: "Blender", description: "High-speed blender for smoothies and shakes."),
                Item(id: 15, itemTitle: "Microwave Oven", description: "Compact microwave with multiple presets.")
            ]),
            Product(title: "Kitchen", items: [
                Item(id: 16, itemTitle: "Coffee Maker", description: "Programmable coffee machine with glass carafe."),
                Item(id: 17, itemTitle: "Blender", description: "High-speed blender for smoothies and shakes."),
                Item(id: 18, itemTitle: "Microwave Oven", description: "Compact microwave with multiple presets."),
               
            ])
        ]
    }
}
