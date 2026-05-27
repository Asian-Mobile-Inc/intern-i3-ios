//
//  Goal.swift
//  VCLifecycle
//
//  Created by Văn Tiến on 05/05/2026.
//

import Foundation

enum Priority: String, CaseIterable {
    case low    = "🟢 Low"
    case medium = "🟡 Medium"
    case high   = "🔴 High"
}

struct Goal {
    let id: UUID
    var title: String
    var detail: String
    var deadline: Date
    var priority: Priority
    var isDone: Bool
    
    init( title: String, detail: String = "", deadline: Date = Date().addingTimeInterval(7*86400), priority: Priority = .low, isDone: Bool = false) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.deadline = deadline
        self.priority = priority
        self.isDone = isDone
    }
}

extension Goal {
    static var sampleData: [Goal] {
        [
            Goal( title: "Học Swift UIKit",     detail: "Hoàn thành 10 project thực chiến", priority: .high),
            Goal( title: "Đọc Clean Code",      detail: "Đọc 30 phút mỗi ngày trước khi ngủ", priority: .medium),
            Goal( title: "Chạy bộ 5km/ngày",   detail: "Sáng sớm, trước 7h",              priority: .medium),
            Goal( title: "Build app cá nhân",   detail: "Deploy lên App Store trước Q2",    priority: .high),
            Goal( title: "Học tiếng Anh",      detail: "Duolingo 15 phút/ngày",            priority: .low, isDone: true),
        ]
    }
}

