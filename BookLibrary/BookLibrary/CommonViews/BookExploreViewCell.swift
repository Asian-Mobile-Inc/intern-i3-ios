//
//  BookExploreViewCell.swift
//  BookLibrary
//
//  Created by Văn Tiến on 02/06/2026.
//

import UIKit

class BookExploreViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publicYear: UILabel!
    
    private var placeholderImage = UIImage(systemName: "book.closed")?
        .withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImage.image = placeholderImage
        coverImage.contentMode = .scaleAspectFit
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        author.text = nil
        bookName.text = nil
        publicYear.text = nil
        coverImage.cancelImageLoading(placeholder: placeholderImage)
    }
    
    func configure(with item: Book) {
        author.text = item.author
        bookName.text = item.title
        publicYear.text = "\(item.firstPublishYear, default: "")"
        coverImage.setImage(from: item.coverURL, placeholder: placeholderImage)
    }
}
