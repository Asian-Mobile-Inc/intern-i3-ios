//
//  QuoteCell.swift
//  MVC
//
//  Created by Văn Tiến on 12/05/2026.
//

import UIKit

protocol QuoteCellDelegate: AnyObject {
    func quoteCell(_ cell: QuoteCell, didTapHeartAt index: Int)
}

class QuoteCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    weak var delegate: QuoteCellDelegate?
    
    private var cellIndex: Int = 0
    
    private var isFavorited: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    private func setupStyle() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        
        contentView.backgroundColor = UIColor.systemGray6
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configure(with quote: Quote, at index: Int) {
        cellIndex = index
        isFavorited = quote.isSelected
        
        idLabel.text = "#\(quote.id)"
        quoteLabel.text = "\"\(quote.quote)\""
        authorLabel.text = "— \(quote.author)"
        
        updateHeartAppearance()
    }
    
    private func updateHeartAppearance() {
        let heartImage = isFavorited
            ? UIImage(systemName: "heart.fill")
            : UIImage(systemName: "heart")
        heartButton.setImage(heartImage, for: .normal)
        heartButton.tintColor = isFavorited ? .systemRed : .systemGray
    }
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        isFavorited.toggle()
        updateHeartAppearance()
        
        UIView.animate(withDuration: 0.15, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                sender.transform = .identity
            }
        }
        
        delegate?.quoteCell(self, didTapHeartAt: cellIndex)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        idLabel.text = nil
        quoteLabel.text = nil
        authorLabel.text = nil
        isFavorited = false
        updateHeartAppearance()
    }
}
