//
//  TaskCell.swift
//  LearningView
//
//  Created by Văn Tiến on 20/04/2026.
//

import UIKit

class TaskCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let statusIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // them subview bang programmatic UI
        contentView.addSubview(statusIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.textColor = .gray
        descLabel.numberOfLines = 0
        descLabel.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with task: TaskModel) {
        titleLabel.text = task.title
        descLabel.text = task.description
        statusIcon.image = UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
        statusIcon.tintColor = task.isCompleted ? .systemGreen : .lightGray

        UIView.animate(withDuration: 0.3) {
            self.descLabel.alpha = task.isExpanded ? 1.0 : 0.0
        }
    }
    //override ham layoutSubviews de custom UI trong view drawin life cycle tiep theo
    override func layoutSubviews() {
        super.layoutSubviews()

        let width = contentView.bounds.width
        let height = contentView.bounds.height

        statusIcon.frame = CGRect(x: 16, y: 16, width: 24, height: 24)
        titleLabel.frame = CGRect(x: 56, y: 16, width: width - 72, height: 24)
        descLabel.frame = CGRect(x: 56, y: 44, width: width - 72, height: height - 52)
    }
}
