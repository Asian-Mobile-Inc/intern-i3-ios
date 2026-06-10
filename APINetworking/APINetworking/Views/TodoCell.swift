//
//  TodoCell.swift
//  APINetworking
//
//  Created by Văn Tiến on 25/05/2026.
//

import UIKit


final class TodoCell: UITableViewCell {
    static let reuseID = "TodoCell"

    private let titleLabel = UILabel()
    private let radioButton = UIButton(type: .system)
    var onTapRadio: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onTapRadio = nil
    }

    func configure(with todo: Todo) {
        titleLabel.text = todo.title
        let iconName = todo.completed ? "largecircle.fill.circle" : "circle"
        radioButton.setImage(UIImage(systemName: iconName), for: .normal)
        titleLabel.textColor = todo.completed ? .secondaryLabel : .label
    }

    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(radioButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 16)
        radioButton.tintColor = .systemBlue

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 28),
            radioButton.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        radioButton.addTarget(self, action: #selector(didTapRadio), for: .touchUpInside)
    }

    @objc private func didTapRadio() {
        onTapRadio?()
    }
}


