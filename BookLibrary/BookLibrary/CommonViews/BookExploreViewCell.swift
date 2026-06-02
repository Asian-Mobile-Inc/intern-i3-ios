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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        author.text = nil
        bookName.text = nil
        publicYear.text = nil
    }
    
    func configure(with item: Book) {
        author.text = item.author
        bookName.text = item.title
        publicYear.text = "\(item.firstPublishYear, default: "")"
    }
}
