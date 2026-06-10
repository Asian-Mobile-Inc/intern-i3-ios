//
//  BookViewCell.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import UIKit

class BookViewCell: UICollectionViewCell {

    @IBOutlet weak var publicYear: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    private var  placeholderImage = UIImage(systemName: "book.closed")?
        .withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        coverImage.image = placeholderImage
        coverImage.contentMode = .scaleAspectFit
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        author.text = nil
        title.text = nil
        publicYear.text = nil
        coverImage.cancelImageLoading(placeholder: placeholderImage)
    }
    
    func configure(with item: Book) {
        author.text = item.author
        title.text = item.title
        publicYear.text = "\(item.firstPublishYear, default: "")"
        coverImage.setImage(from: item.coverURL, placeholder: placeholderImage)
    }
}
