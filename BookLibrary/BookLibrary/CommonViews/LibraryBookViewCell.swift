//
//  LibraryBookViewCell.swift
//  BookLibrary
//
//  Created by Văn Tiến on 04/06/2026.
//

import UIKit

class LibraryBookViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publicYearLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    var onStateChange: ((SavedBook, SavedBookState) -> Void)?

    private var savedBook: SavedBook?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .secondarySystemGroupedBackground

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.masksToBounds = false

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 2

        authorLabel.font = .preferredFont(forTextStyle: .subheadline)
        authorLabel.textColor = .secondaryLabel

        publicYearLabel.font = .preferredFont(forTextStyle: .subheadline)
        publicYearLabel.textColor = .tertiaryLabel

        statusButton.showsMenuAsPrimaryAction = true
        statusButton.changesSelectionAsPrimaryAction = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        savedBook = nil
        onStateChange = nil
        titleLabel.text = nil
        authorLabel.text = nil
        publicYearLabel.text = nil
        statusButton.configuration = nil
        statusButton.menu = nil
        statusButton.setTitle(nil, for: .normal)
    }

    func configure(with item: SavedBook) {
        savedBook = item
        titleLabel.text = item.title
        authorLabel.text = item.author
        publicYearLabel.text = "\(item.firstPublishYear, default: "")"
        apply(state: item.state)
    }

    private func apply(state: SavedBookState) {
        contentView.backgroundColor = state.cellBackgroundColor

        var configuration = UIButton.Configuration.filled()
        configuration.title = state.rawValue
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 10)
        configuration.baseForegroundColor = state.foregroundColor
        configuration.baseBackgroundColor = state.backgroundColor

        statusButton.configuration = configuration
        statusButton.setTitle(state.rawValue, for: .normal)
        statusButton.setTitle(state.rawValue, for: .highlighted)
        statusButton.setTitle(state.rawValue, for: .selected)
        statusButton.setNeedsUpdateConfiguration()
        statusButton.menu = makeMenu(selectedState: state)
    }

    private func makeMenu(selectedState: SavedBookState) -> UIMenu {
        let actions = SavedBookState.allCases.map { bookState in
            UIAction(
                title: bookState.rawValue,
                image: UIImage(systemName: bookState.iconName),
                state: bookState == selectedState ? .on : .off
            ) { [weak self] _ in
                self?.select(bookState)
            }
        }

        return UIMenu(title: "", options: .displayInline, children: actions)
    }

    private func select(_ state: SavedBookState) {
        guard let savedBook else { return }

        savedBook.state = state
        apply(state: state)
        onStateChange?(savedBook, state)
    }
}
