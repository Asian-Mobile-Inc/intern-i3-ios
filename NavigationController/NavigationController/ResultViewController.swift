//
//  ResultViewController.swift
//  NavigationController
//
//  Created by Văn Tiến on 08/05/2026.
//

import UIKit

class ResultViewController: UIViewController {
    
    let score: Int
    let total: Int
    let testTitle: String
    
    // MARK: - UI Elements
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let messageLabel = UILabel()
    private let homeButton = UIButton(type: .system)
    
    // MARK: - Init
    init(score: Int, total: Int, testTitle: String) {
        self.score = score
        self.total = total
        self.testTitle = testTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupResultUI()
    }
    
    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        title = "Kết quả"
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Setup Result UI
    private func setupResultUI() {
        let percentage = Double(score) / Double(total) * 100
        
        // --- Emoji Label ---
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = emojiForScore(percentage: percentage)
        emojiLabel.font = UIFont.systemFont(ofSize: 80)
        emojiLabel.textAlignment = .center
        view.addSubview(emojiLabel)
        
        // --- Title Label ---
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = testTitle
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // --- Score Label ---
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "\(score) / \(total)"
        scoreLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        scoreLabel.textColor = colorForScore(percentage: percentage)
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
        
        // --- Message Label ---
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = messageForScore(percentage: percentage)
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        messageLabel.textColor = .label
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        
        // --- Home Button ---
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.setTitle("Về Home", for: .normal)
        homeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        homeButton.backgroundColor = .systemBlue
        homeButton.setTitleColor(.white, for: .normal)
        homeButton.layer.cornerRadius = 14
        homeButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        view.addSubview(homeButton)
        
        // MARK: - Auto Layout
        NSLayoutConstraint.activate([
            // Emoji
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            
            // Title
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Score
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            // Message
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Home Button
            homeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            homeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            homeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            homeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            homeButton.heightAnchor.constraint(equalToConstant: 54),
        ])
    }
    
    // MARK: - Actions
    @objc private func goHome() {
        // Quay về root (HomeViewController)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Helpers
    private func emojiForScore(percentage: Double) -> String {
        switch percentage {
        case 90...100: return "🏆"
        case 70..<90:  return "😊"
        case 50..<70:  return "🤔"
        default:       return "😢"
        }
    }
    
    private func colorForScore(percentage: Double) -> UIColor {
        switch percentage {
        case 70...100: return .systemGreen
        case 50..<70:  return .systemOrange
        default:       return .systemRed
        }
    }
    
    private func messageForScore(percentage: Double) -> String {
        switch percentage {
        case 90...100: return "Bạn làm tốt lắm"
        case 70..<90:  return "Cố gắng thêm nhé"
        case 50..<70:  return "Hãy ôn lại bài nhé"
        default:       return "Cần cố gắng nhiều hơn"
        }
    }
}
