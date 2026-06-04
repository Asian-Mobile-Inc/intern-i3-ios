//
//  BookDetailViewController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 03/06/2026.
//

import UIKit
import Combine

class BookDetailViewController: UIViewController {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var publicYear: UILabel!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var viewModel: BookDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "BookDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }

    func setupUI() {
        bookName.text = viewModel.book.title
        authorName.text = viewModel.book.author
        coverImage.setImage(from: viewModel.book.coverURL)
        publicYear.text = "Public Year : \(viewModel.book.firstPublishYear, default: "Unknown")"
        updateSaveButton(isSaved: viewModel.isSaved)
    }

    func bindViewModel() {
        viewModel.$isSaved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSave in
                guard let self = self else { return }
                self.updateSaveButton(isSaved: isSave)
            }
            .store(in: &cancellables)
        
        viewModel.$message
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                if let message {
                    showSuccessPopup(title: "Success!", message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateSaveButton(isSaved: Bool) {
        let title = isSaved ? "Saved" : "Save"
        let titleColor: UIColor = isSaved ? .red : .white
        
        saveButton.setTitle(title, for: .normal)
        saveButton.setTitle(title, for: .disabled)
        saveButton.isEnabled = !isSaved
        saveButton.tintColor = isSaved ? .systemGray6 : .systemBlue
        saveButton.setTitleColor(titleColor, for: .normal)
        saveButton.setTitleColor(titleColor, for: .disabled)
    }
    
    func showSuccessPopup(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func didTapSaveBookButton(_ sender: Any) {
        viewModel.saveBook()
    }
    
}
