//
//  Model.swift
//  NavigationController
//
//  Created by Văn Tiến on 07/05/2026.
//

import Foundation

struct Question {
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
}

struct Test {
    let id: UUID = UUID()
    let title: String
    let questions: [Question]
}

struct TestResult {
    let testID: UUID
    let testTitle: String
    let score: Int
    let totalQuestions: Int
    let date: Date
}
