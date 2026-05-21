//
//  HomeViewController.swift
//  NavigationController
//
//  Created by Văn Tiến on 07/05/2026.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // 1. Đặt tiêu đề cho Navigation Bar
        self.title = "Chọn Bài Test "
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // 2. Tạo StackView để chứa các nút bài test
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // 3. Thiết lập Auto Layout cho StackView nằm giữa màn hình
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        // 4. Tạo 4 nút mô phỏng 4 bài test
        for i in 1...4 {
            let testButton = UIButton(type: .system)
            testButton.setTitle("Bài Test số \(i)", for: .normal)
            testButton.backgroundColor = .systemBlue
            testButton.setTitleColor(.white, for: .normal)
            testButton.layer.cornerRadius = 10
            testButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            stackView.addArrangedSubview(testButton)
            
            testButton.tag = i // Đánh dấu bài test 1, 2, 3, 4
            testButton.addTarget(self, action: #selector(startTest(_:)), for: .touchUpInside)

            
        }
    }

    @objc private func startTest(_ sender: UIButton) {
        let testNumber = sender.tag
        
        // Tạo dữ liệu giả lập cho 10 câu hỏi
        let dummyQuestions = (1...10).map { i in
            Question(text: "Câu hỏi số \(i) của bài Test \(testNumber)?",
                     options: ["Đáp án A", "Đáp án B", "Đáp án C", "Đáp án D"],
                     correctAnswerIndex: 0)
        }
        
        let selectedTest = Test(title: "Bài Test \(testNumber)", questions: dummyQuestions)
        
        // Khởi tạo màn hình câu hỏi đầu tiên
        let questionVC = QuestionViewController(test: selectedTest, questionIndex: 0, currentScore: 0)
        
        // Đẩy màn hình vào Stack (Push)
        self.navigationController?.pushViewController(questionVC, animated: true)
    }
}
