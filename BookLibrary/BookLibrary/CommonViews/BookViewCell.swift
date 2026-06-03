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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        author.text = nil
        title.text = nil
        publicYear.text = nil
    }
    
    func configure(with item: Book) {
        author.text = item.author
        title.text = item.title
        publicYear.text = "\(item.firstPublishYear, default: "")"
    }
}
