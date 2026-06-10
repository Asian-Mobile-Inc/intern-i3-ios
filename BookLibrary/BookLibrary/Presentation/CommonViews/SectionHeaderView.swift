//
//  SectionHeaderViewCell.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
       
   private let titleLabel = UILabel()
   
   override init(frame: CGRect) {
       super.init(frame: frame)
       setupUI()
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   
   private func setupUI() {
       titleLabel.font = .boldSystemFont(ofSize: 20)
       titleLabel.textColor = .label
       titleLabel.translatesAutoresizingMaskIntoConstraints = false
       
       addSubview(titleLabel)
       
       NSLayoutConstraint.activate([
           titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
           titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
           titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
       ])
   }
   
   func configure(with title: String) {
       titleLabel.text = title
   }
   
   override func prepareForReuse() {
       super.prepareForReuse()
       titleLabel.text = nil
   }
}
