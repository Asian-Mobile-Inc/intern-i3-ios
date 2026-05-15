//
//  CardView.swift
//  StackView
//
//  Created by Văn Tiến on 28/04/2026.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!

        var onDeleteTapped: (() -> Void)?
        @IBAction func deleteButtonTapped(_ sender: UIButton) {
            print("123")
            onDeleteTapped?()
        }

        static func loadFromNib() -> CardView {
            let bundle = Bundle(for: self)
            let nib = UINib(nibName: "CardView", bundle: bundle)
            
        guard let customView = nib.instantiate(withOwner: nil, options: nil).first as? CardView else {
                    fatalError("Không thể load CardView từ XIB. Kiểm tra lại tên file hoặc Class Identity.")
                }
                
            customView.translatesAutoresizingMaskIntoConstraints = false
            
            customView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            customView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            return customView
        }

}
