//
//  AppDIContainer.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation

@MainActor
final class AppDIContainer {
    private lazy var apiService = APIService()
    private lazy var remoteDataSource = BookRemoteDataSource(
        apiService: apiService
    )
    private lazy var localDataSource = BookLocalDataSource()
    private lazy var repository = Repository(
        bookLocalDS: localDataSource,
        bookRemoteDS: remoteDataSource
    )

    func makeExploreViewController() -> ExploreViewController {
        let viewModel = ExploreViewModel(
            repository: repository
        )

        return ExploreViewController(
            viewModel: viewModel,
            makeBookDetailViewController: makeBookDetailViewController
        )
    }

    func makeSearchViewController() -> SearchViewController {
        let useCase = SearchBookUseCase(
            repository: repository
        )

        let viewModel = SearchViewModel(
            searchBooksUseCase: useCase
        )

        return SearchViewController(
            viewModel: viewModel,
            makeBookDetailViewController: makeBookDetailViewController
        )
    }

    func makeBookDetailViewController(book: Book) -> BookDetailViewController {
        let useCase = SaveBookUseCase(
            repository: repository
        )
        let viewModel = BookDetailViewModel(
            book: book,
            saveBookUseCase: useCase
        )

        return BookDetailViewController(viewModel: viewModel)
    }
}
