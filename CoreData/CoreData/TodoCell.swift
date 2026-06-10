//
//  TodoCell.swift
//  CoreData
//
//  Created by Codex on 28/05/2026.
//

import UIKit

final class TodoCell: UITableViewCell {

    static let reuseID = "TodoCell"
    var onTapRadioButton: (() -> Void)?

    private let radioButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemGray3
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryView = radioButton
        radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with todo: TodoEntity) {
        textLabel?.text = todo.title
        let symbolName = todo.isDone ? "largecircle.fill.circle" : "circle"
        let image = UIImage(
            systemName: symbolName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        )
        radioButton.setImage(image, for: .normal)
        radioButton.tintColor = todo.isDone ? .systemBlue : .systemGray3
    }

    @objc private func radioButtonTapped() {
        onTapRadioButton?()
    }
}
