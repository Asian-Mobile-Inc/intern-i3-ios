//
//  User.swift
//  CollectionView
//
//  Created by Văn Tiến on 13/05/2026.
//

import Foundation

final class User {
    var name: String
    var avatar: String

    init(name: String, avatar: String) {
       self.name = name
       self.avatar = avatar
    }
}

extension User {
    static func getUser() -> [User] {
        var users: [User] = []
                
        for i in 1...30 {
            let user = User(name: "User \(i)", avatar: "\(i%10)")
            users.append(user)
        }
        
        return users
    }
}
