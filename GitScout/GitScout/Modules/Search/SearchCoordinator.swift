//
//  SearchCoordinator.swift
//  GitScout
//
//  Created by Влад Шимченко on 25.08.2026.
//

import UIKit
import Combine

final class SearchCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let persistenceController: PersistenceControllerProtocol
    private let favoritesStorage: FavoritesStorageProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        navigationController: UINavigationController,
        persistenceController: PersistenceControllerProtocol,
        favoritesStorage: FavoritesStorageProtocol
    ) {
        self.navigationController = navigationController
        self.persistenceController = persistenceController
        self.favoritesStorage = favoritesStorage
    }

    func start() {
        let interactor = SearchInteractor()
        let searchViewModel = SearchViewModel(interactor: interactor)
        let searchVC = SearchViewController(viewModel: searchViewModel)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 0)

        searchViewModel.didSelectRepo
            .sink { [weak self] repo in
                self?.showDetail(for: repo)
            }
            .store(in: &cancellables)

        navigationController.setViewControllers([searchVC], animated: false)
    }

    private func showDetail(for repo: GitHubRepo) {
        let interactor = DetailInteractor()
        let viewModel = DetailViewModel(
            repo: repo,
            interactor: interactor,
            favoritesStorage: favoritesStorage
        )
        let detailVC = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
