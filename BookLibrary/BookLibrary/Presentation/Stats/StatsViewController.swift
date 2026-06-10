//
//  StatsViewController.swift
//  BookLibrary
//
//  Created by Văn Tiến on 01/06/2026.
//

import Combine
import UIKit

class StatsViewController: UIViewController {

  @IBOutlet weak var readingCount: UILabel!
  @IBOutlet weak var finishedCount: UILabel!
  @IBOutlet weak var willReadCount: UILabel!

  private let viewModel = StatsViewModel()
  private var cancellables = Set<AnyCancellable>()
  private var loadingIndicator = UIActivityIndicatorView(style: .medium)

  private let emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "You should save some books!"
    label.textColor = .secondaryLabel
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    title = "Stats"

    setupUI()
    setupLoadingIndicator()
    setupEmptyLabel()
    bindViewModel()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    viewModel.fetchStats()
  }

  private func setupUI() {
    updateStats(viewModel.stats)
  }

  private func setupLoadingIndicator() {
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingIndicator)

    NSLayoutConstraint.activate([
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
    ])
  }

  private func setupEmptyLabel() {
    view.addSubview(emptyLabel)

    NSLayoutConstraint.activate([
      emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
      emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
    ])
  }

  private func bindViewModel() {
    viewModel.$stats
      .receive(on: DispatchQueue.main)
      .sink { [weak self] stats in
        guard let self else { return }

        self.updateStats(stats)
        self.updateEmptyState()
      }
      .store(in: &cancellables)

    viewModel.$isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        guard let self else { return }

        if isLoading {
          self.loadingIndicator.startAnimating()
          self.emptyLabel.isHidden = true
        } else {
          self.loadingIndicator.stopAnimating()
          self.updateEmptyState()
        }
      }
      .store(in: &cancellables)

    viewModel.$errorMessage
      .receive(on: DispatchQueue.main)
      .sink { [weak self] errorMessage in
        guard let self else { return }

        if let errorMessage {
          self.emptyLabel.text = errorMessage
          self.emptyLabel.isHidden = false
        } else {
          self.updateEmptyState()
        }
      }
      .store(in: &cancellables)
  }

  private func updateStats(_ stats: ReadingStats) {
    willReadCount.text = String(stats.wantToReadCount)
    readingCount.text = String(stats.readingCount)
    finishedCount.text = String(stats.finishedCount)
  }

  private func updateEmptyState() {
    guard !viewModel.isLoading else {
      emptyLabel.isHidden = true
      return
    }

    if let errorMessage = viewModel.errorMessage {
      emptyLabel.text = errorMessage
      emptyLabel.isHidden = false
      return
    }

    if viewModel.stats.total == 0 {
      emptyLabel.text = "You should save some books!"
      emptyLabel.isHidden = false
      return
    }

    emptyLabel.isHidden = true
  }
}
