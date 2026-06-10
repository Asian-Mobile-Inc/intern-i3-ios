//
//  AppDIContainer.swift
//  BookLibrary
//
//  Created by Văn Tiến on 10/06/2026.
//

import Foundation

final class AppDIContainer {
    func makeSearchViewController() -> SearchViewController {
        let apiService = APIService()

        let remoteDS = BookRemoteDataSource(
            apiService: apiService
        )

        let localDS = BookLocalDataSource()

        let repository = Repository(
            bookLocalDS: localDS,
            bookRemoteDS: remoteDS
        )

        let useCase = SearchBookUseCase(
            repository: repository
        )

        let viewModel = SearchViewModel(
            searchBooksUseCase: useCase
        )

        return SearchViewController(viewModel: viewModel)
    }
}
