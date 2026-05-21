//
//  GoalCell.swift
//  VCLifecycle
//
//  Created by Văn Tiến on 05/05/2026.
//

import UIKit

protocol GoalCellDelegate: AnyObject {
    func goalCell(_ cell: GoalCell)
}

class GoalCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityBadge: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate : GoalCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        if let wrapper = containerView.superview {
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 12),
                containerView.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -12),
                containerView.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 4),
                containerView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -4)
            ])
        }
        
        if let stack = containerView.subviews.first(where: { $0 is UIStackView }) {
            stack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
                stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
            ])
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
       super.prepareForReuse()
       titleLabel.alpha = 1
//       layer.transform = .identty
       titleLabel.attributedText = nil
    }

    private func setupStyle() {
       selectionStyle = .none
       backgroundColor = .clear

       containerView.backgroundColor = .systemBackground
       containerView.layer.cornerRadius = 14
       containerView.layer.shadowColor  = UIColor.black.cgColor
       containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
       containerView.layer.shadowRadius = 6
       containerView.layer.shadowOpacity = 0.08

       priorityBadge.layer.cornerRadius = 6
       priorityBadge.layer.masksToBounds = true
       priorityBadge.backgroundColor = .systemBlue.withAlphaComponent(0.12)
    }
    func configure(with goal: Goal) {
        priorityBadge.text = " \(goal.priority.rawValue) "
        deadlineLabel.text = "📅 \(formatDate(goal.deadline))"

        if goal.isDone {
            let attrs: [NSAttributedString.Key: Any] = [
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.tertiaryLabel
            ]
            titleLabel.attributedText = NSAttributedString(string: goal.title, attributes: attrs)
            doneButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            doneButton.tintColor = .systemGreen
        } else {
            titleLabel.attributedText = nil
            titleLabel.text = goal.title
            titleLabel.textColor = .label
            doneButton.setImage(UIImage(systemName: "circle"), for: .normal)
            doneButton.tintColor = .systemGray3
        }
    }
    
    private func formatDate(_ date: Date) -> String {
       let fmt = DateFormatter()
        fmt.dateStyle = .medium; fmt.locale = Locale(identifier: "vi_VN")
       return fmt.string(from: date)
   }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        delegate?.goalCell(self)
    }
}
