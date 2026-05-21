//
//  Menu.swift
//  TableView
//
//  Created by Văn Tiến on 11/05/2026.
//

import Foundation

struct Menu {
    let title : String
    var items : [Item]
}

struct Item {
    var name : String
    var isSelected : Bool = false
}

extension Menu {
    static var data : [Menu] {
        [
            Menu(title: "Khai vị", items: [
                Item(name: "Gỏi cuốn"), Item(name: "Chả giò"), Item(name: "Bò bía"), Item(name: "Gỏi ngó sen"),
                Item(name: "Chả giò 2"), Item(name: "Bò bía 2"), Item(name: "Chả giò 3"), Item(name: "Bò bía 3"),
                Item(name: "Chả giò 4"), Item(name: "Bò bía 4"), Item(name: "Chè ba màu 3"), Item(name: "Bánh flan 3"),
                Item(name: "Bánh flan 4"), Item(name: "Chè ba màu 4"), Item(name: "Bánh flan 5"), Item(name: "Bánh flan 6")
            ]),
            Menu(title: "Món chính", items: [
                Item(name: "Phở bò"), Item(name: "Bún bò"), Item(name: "Cơm tấm"), Item(name: "Bò sốt vang"),
                Item(name: "Bò sốt vang 2"), Item(name: "Bò sốt vang 3"), Item(name: "Bò sốt vang 4"),
                Item(name: "Bò sốt vang 5"), Item(name: "Bò sốt vang 6"), Item(name: "Bò sốt vang 7")
            ]),
            Menu(title: "Tráng miệng", items: [
                Item(name: "Chè ba màu"), Item(name: "Bánh flan"), Item(name: "Chè ba màu 2"), Item(name: "Bánh flan 2")
            ]),
            Menu(title: "Tráng miệng", items: [Item(name: "Chè ba màu"), Item(name: "Bánh flan")]),
            Menu(title: "Tráng miệng", items: [Item(name: "Chè ba màu"), Item(name: "Bánh flan")]),
            Menu(title: "Tráng miệng", items: [Item(name: "Chè ba màu"), Item(name: "Bánh flan")]),
            Menu(title: "Tráng miệng", items: [Item(name: "Chè ba màu"), Item(name: "Bánh flan")]),
        ]
    }
}
