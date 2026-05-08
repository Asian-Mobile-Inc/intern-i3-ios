//
//  QuestionViewController.swift
//  NavigationController
//
//  Created by Văn Tiến on 07/05/2026.
//

import UIKit

class QuestionViewController: UIViewController {
    
    let test: Test
    let questionIndex: Int
    var currentScore: Int
    
    // MARK: - UI Elements
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let questionLabel = UILabel()
    private let questionNumberLabel = UILabel()
    private let scoreLabel = UILabel()
    private var answerButtons: [UIButton] = []
    private let stackView = UIStackView()
    
    // Init để nhận dữ liệu (Initializer Injection)
    init(test: Test, questionIndex: Int, currentScore: Int) {
        self.test = test
        self.questionIndex = questionIndex
        self.currentScore = currentScore
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupQuestionUI()
        setupNavigationBar()
    }
    
    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        title = "Câu \(questionIndex + 1)/\(test.questions.count)"
        
        // Tạo nút "X" ở góc phải
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(exitTest))
        navigationItem.rightBarButtonItem = closeButton
         navigationItem.hidesBackButton = true
    }
    
    @objc private func exitTest() {
        // Quay thẳng về Home (Gốc của Navigation Stack)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Setup Question UI
    private func setupQuestionUI() {
        let question = test.questions[questionIndex]
        
        // --- Progress View ---
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        let progress = Float(questionIndex + 1) / Float(test.questions.count)
        progressView.setProgress(progress, animated: false)
        view.addSubview(progressView)
        
        // --- Score Label (hiện điểm hiện tại) ---
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Điểm: \(currentScore)"
        scoreLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        scoreLabel.textColor = .systemGreen
        scoreLabel.textAlignment = .right
        view.addSubview(scoreLabel)
        
        // --- Question Number Label ---
        questionNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        questionNumberLabel.text = "Câu hỏi \(questionIndex + 1) / \(test.questions.count)"
        questionNumberLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        questionNumberLabel.textColor = .secondaryLabel
        questionNumberLabel.textAlignment = .left
        view.addSubview(questionNumberLabel)
        
        // --- Question Label ---
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = question.text
        questionLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        questionLabel.textColor = .label
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
        
        // --- Answer Buttons StackView ---
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        // Tạo 4 nút đáp án (A, B, C, D)
        let prefixes = ["A", "B", "C", "D"]
        for (index, option) in question.options.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle("  \(prefixes[index]). \(option)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.numberOfLines = 0
            button.backgroundColor = .secondarySystemGroupedBackground
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            answerButtons.append(button)
        }
        
        // MARK: - Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Progress View
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            // Score Label
            scoreLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Question Number Label
            questionNumberLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 12),
            questionNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionNumberLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -8),
            
            // Question Label
            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 30),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Answer StackView
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Answer Tapped
    @objc private func answerButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        let question = test.questions[questionIndex]
        let isCorrect = (selectedIndex == question.correctAnswerIndex)
        
        // Disable tất cả nút sau khi chọn (tránh nhấn nhiều lần)
        answerButtons.forEach { $0.isUserInteractionEnabled = false }
        
        // Highlight đáp án đúng/sai
        highlightAnswers(selectedIndex: selectedIndex, correctIndex: question.correctAnswerIndex)
        
        // Chờ 1 giây rồi chuyển sang câu tiếp theo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.answerTapped(isCorrect: isCorrect)
        }
    }
    
    private func highlightAnswers(selectedIndex: Int, correctIndex: Int) {
        // Highlight đáp án đúng bằng màu xanh
        let correctButton = answerButtons[correctIndex]
        correctButton.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        correctButton.layer.borderColor = UIColor.systemGreen.cgColor
        
        // Nếu chọn sai, highlight đáp án đã chọn bằng màu đỏ
        if selectedIndex != correctIndex {
            let wrongButton = answerButtons[selectedIndex]
            wrongButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.3)
            wrongButton.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    // MARK: - Navigation Logic
    func answerTapped(isCorrect: Bool) {
        let nextScore = isCorrect ? currentScore + 1 : currentScore
        let nextIndex = questionIndex + 1
        
        if nextIndex < test.questions.count {
            // Còn câu hỏi -> Push tiếp màn hình câu hỏi tiếp theo
            let nextVC = QuestionViewController(test: test, questionIndex: nextIndex, currentScore: nextScore)
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            // Hết câu hỏi -> Push sang màn hình kết quả
            let resultVC = ResultViewController(score: nextScore, total: test.questions.count, testTitle: test.title)
            navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}
