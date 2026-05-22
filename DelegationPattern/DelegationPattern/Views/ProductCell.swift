//
//  ProductCell.swift
//  DelegationPattern
//
//  Created by Văn Tiến on 01/05/2026.
//

import UIKit

class ProductCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    weak var delegate: ProductCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
     categoryLabel.layer.cornerRadius = 4
     categoryLabel.layer.masksToBounds = true
     categoryLabel.backgroundColor = .systemBlue.withAlphaComponent(0.15)
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = String(product.price)
        categoryLabel.text = product.category

        let heartImage = product.isFavorite ? "heart.fill" : "heart"
        let tint: UIColor = product.isFavorite ? .systemRed : .systemGray3
        favoriteButton.setImage(UIImage(systemName: heartImage), for: .normal)
        favoriteButton.tintColor = tint
        
      }
    
    @IBAction func didTapFavButton(_ sender: UIButton) {
        delegate?.productCell (self)
    }
}


protocol ProductCellDelegate: AnyObject {
    
    func productCell(_ cell: ProductCell)
}
