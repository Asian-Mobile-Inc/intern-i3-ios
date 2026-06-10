//
//  SavedBookDetailViewController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 05/06/2026.
//

import Combine
import UIKit

class SavedBookDetailViewController: UIViewController {

  @IBOutlet weak var updateButton: UIButton!
  @IBOutlet weak var ratingButton: UIButton!
  @IBOutlet weak var note: UITextView!
  @IBOutlet weak var statusButton: UIButton!
  @IBOutlet weak var publicYear: UILabel!
  @IBOutlet weak var author: UILabel!
  @IBOutlet weak var bookName: UILabel!
  @IBOutlet weak var coverImage: UIImageView!

  private let viewModel: SavedBookDetailViewModel
  private var cancellables = Set<AnyCancellable>()
  private var originalNote = ""
  private var originalRating = 0.0
  private var originalStatus = SavedBookState.wantToRead
  private var selectedRating = 0.0
  private var selectedStatus = SavedBookState.wantToRead
  private let ratingValues = Array(stride(from: 0.0, through: 5.0, by: 0.5))

  init(viewModel: SavedBookDetailViewModel) {
    self.viewModel = viewModel
    super.init(nibName: "SavedBookDetailViewController", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindViewModel()

  }

  private func setupUI() {
    bookName.text = viewModel.savedBook.title
    author.text = viewModel.savedBook.author
    coverImage.setImage(from: viewModel.savedBook.coverURL)
    publicYear.text = "Public Year : \(viewModel.savedBook.firstPublishYear, default: "Unknown")"
    note.text = viewModel.savedBook.note
    note.delegate = self
    note.layer.borderWidth = 1
    note.layer.borderColor = UIColor.separator.cgColor
    note.layer.cornerRadius = 8
    note.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    note.inputAccessoryView = makeKeyboardToolbar()

    originalNote = viewModel.savedBook.note
    originalRating = viewModel.savedBook.rating
    originalStatus = viewModel.savedBook.state
    selectedRating = viewModel.savedBook.rating
    selectedStatus = viewModel.savedBook.state

    setupStatusButton()
    setupRatingButton()
    setupUpdateButton()
    setupKeyboardDismissGesture()
    updateSaveButtonState()
  }

  private func bindViewModel() {
    viewModel.$isUpdated
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isUpdated in
        guard let self, isUpdated else { return }

        self.originalNote = self.note.text ?? ""
        self.originalRating = self.selectedRating
        self.originalStatus = self.selectedStatus
        self.updateSaveButtonState()
      }
      .store(in: &cancellables)

    viewModel.$message
      .receive(on: DispatchQueue.main)
      .sink { [weak self] message in
        guard let self, let message else { return }

        let isSuccess = message == "Your update was saved"
        self.showPopup(title: isSuccess ? "Saved" : "Error", message: message)
        self.updateSaveButtonState()
      }
      .store(in: &cancellables)
  }

  private func setupUpdateButton() {
    updateButton.setTitle("Save", for: .normal)
    updateButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
  }

  private func setupKeyboardDismissGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }

  private func makeKeyboardToolbar() -> UIToolbar {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()

    let flexibleSpace = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(dismissKeyboard)
    )

    toolbar.items = [flexibleSpace, doneButton]
    return toolbar
  }

  private func setupStatusButton() {
    statusButton.showsMenuAsPrimaryAction = true
    statusButton.changesSelectionAsPrimaryAction = false
    applyStatusButton()
  }

  private func setupRatingButton() {
    ratingButton.showsMenuAsPrimaryAction = true
    ratingButton.changesSelectionAsPrimaryAction = false
    applyRatingButton()
  }

  private func applyStatusButton() {
    let title = selectedStatus.rawValue
    var configuration = UIButton.Configuration.filled()
    configuration.title = title
    configuration.image = UIImage(systemName: "chevron.down")
    configuration.imagePlacement = .trailing
    configuration.imagePadding = 6
    configuration.cornerStyle = .capsule
    configuration.baseForegroundColor = selectedStatus.foregroundColor
    configuration.baseBackgroundColor = selectedStatus.backgroundColor

    statusButton.configuration = configuration
    statusButton.setTitle(title, for: .normal)
    statusButton.setTitle(title, for: .highlighted)
    statusButton.setTitle(title, for: .selected)
    statusButton.menu = makeStatusMenu()
    statusButton.setNeedsUpdateConfiguration()
  }

  private func makeStatusMenu() -> UIMenu {
    let actions = SavedBookState.allCases.map { state in
      UIAction(
        title: state.rawValue,
        image: UIImage(systemName: state.iconName),
        state: state == selectedStatus ? .on : .off
      ) { [weak self] _ in
        guard let self else { return }

        self.selectedStatus = state
        self.applyStatusButton()
        self.updateSaveButtonState()
      }
    }

    return UIMenu(title: "", options: .displayInline, children: actions)
  }

  private func applyRatingButton() {
    let title = ratingTitle(for: selectedRating)
    var configuration = UIButton.Configuration.filled()
    configuration.title = title
    configuration.image = UIImage(systemName: "star.fill")
    configuration.imagePlacement = .leading
    configuration.imagePadding = 6
    configuration.cornerStyle = .capsule
    configuration.baseForegroundColor = .systemYellow
    configuration.baseBackgroundColor = UIColor.systemYellow.withAlphaComponent(0.14)

    ratingButton.configuration = configuration
    ratingButton.setTitle(title, for: .normal)
    ratingButton.setTitle(title, for: .highlighted)
    ratingButton.setTitle(title, for: .selected)
    ratingButton.menu = makeRatingMenu()
    ratingButton.setNeedsUpdateConfiguration()
  }

  private func makeRatingMenu() -> UIMenu {
    let actions = ratingValues.map { rating in
      UIAction(
        title: ratingTitle(for: rating),
        state: rating == selectedRating ? .on : .off
      ) { [weak self] _ in
        guard let self else { return }

        self.selectedRating = rating
        self.applyRatingButton()
        self.updateSaveButtonState()
      }
    }

    return UIMenu(title: "", options: .displayInline, children: actions)
  }

  private func ratingTitle(for rating: Double) -> String {
    if rating == 0 {
      return "No rating"
    }

    return "\(rating.cleanValue)/5"
  }

  private func updateSaveButtonState() {
    let hasChanges =
      (note.text ?? "") != originalNote || selectedRating != originalRating
      || selectedStatus != originalStatus

    updateButton.isEnabled = hasChanges
    updateButton.alpha = hasChanges ? 1 : 0.5
  }

  @objc private func didTapSaveButton() {
    viewModel.savedBook.note = note.text ?? ""
    viewModel.savedBook.rating = selectedRating
    viewModel.savedBook.state = selectedStatus
    updateButton.isEnabled = false
    updateButton.alpha = 0.5
    viewModel.updateSavedBook(book: viewModel.savedBook)
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }

  private func showPopup(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

extension SavedBookDetailViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    updateSaveButtonState()
  }
}

extension Double {
  fileprivate var cleanValue: String {
    truncatingRemainder(dividingBy: 1) == 0 ? String(Int(self)) : String(self)
  }
}
