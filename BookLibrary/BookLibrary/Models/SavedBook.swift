//
//  SavedBook.swift
//  BookLibrary
//
//  Created by Văn Tiến on 04/06/2026.
//

import UIKit

enum SavedBookState: String, CaseIterable {
  case wantToRead = "Want To Read"
  case reading = "Reading"
  case read = "Read"

  init(status: String) {
    self = Self.allCases.first { $0.rawValue == status } ?? .wantToRead
  }

  var iconName: String {
    switch self {
    case .wantToRead:
      return "bookmark"
    case .reading:
      return "book"
    case .read:
      return "checkmark.circle"
    }
  }

  var foregroundColor: UIColor {
    switch self {
    case .wantToRead:
      return .systemOrange
    case .reading:
      return .systemBlue
    case .read:
      return .systemGreen
    }
  }

  var backgroundColor: UIColor {
    foregroundColor.withAlphaComponent(0.14)
  }

  var cellBackgroundColor: UIColor {
    foregroundColor.withAlphaComponent(0.06)
  }
}

class SavedBook: Hashable {
  let id: String
  let title: String
  let author: String
  let firstPublishYear: Int?
  let coverID: Int?
  var note: String = ""
  var rating: Double
  var status: String = "Want To Read"
  var creatAt: Date = .now
  var state: SavedBookState {
    get { SavedBookState(status: status) }
    set { status = newValue.rawValue }
  }

  var coverURL: URL? {
    guard let coverID, coverID > 0 else {
      return nil
    }

    return URL(string: "https://covers.openlibrary.org/b/id/\(coverID)-M.jpg")
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: SavedBook, rhs: SavedBook) -> Bool {
    lhs.id == rhs.id
  }

  init(entity: SavedBookEntity) {
    self.id = entity.id ?? UUID().uuidString
    self.author = entity.author ?? "Unknown Author"
    self.title = entity.title ?? "Unknown book title"
    self.firstPublishYear = Int(entity.publicYear)
    let entityCoverID = Int(entity.coverID)
    self.coverID = entityCoverID > 0 ? entityCoverID : nil
    self.note = entity.note ?? ""
    self.rating = entity.rating
    self.status = entity.status ?? "Want To Read"
    self.creatAt = entity.createAt ?? .now
  }

}

extension SavedBookEntity {
  func update(from savedBook: SavedBook) {
    self.id = savedBook.id
    self.title = savedBook.title
    self.author = savedBook.author
    self.publicYear = Int64(savedBook.firstPublishYear ?? 0)
    self.coverID = Int64(savedBook.coverID ?? 0)
    self.note = savedBook.note
    self.rating = savedBook.rating
    self.status = savedBook.status
    self.createAt = savedBook.creatAt
  }

  func updateFromBook(from book: Book) {
    self.id = book.id
    self.title = book.title
    self.author = book.author
    self.publicYear = Int64(book.firstPublishYear ?? 0)
    self.coverID = Int64(book.coverID ?? 0)
    self.note = ""
    self.rating = 0.0
    self.status = "Want To Read"
    self.createAt = .now
  }
}
