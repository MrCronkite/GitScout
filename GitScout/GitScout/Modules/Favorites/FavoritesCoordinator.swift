//
//  FavoritesCoordinator.swift
//  GitScout
//
//  Created by Влад Шимченко on 25.08.2026.
//

import UIKit
import Combine


final class FavoritesCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let persistenceController: PersistenceControllerProtocol
    private let favoritesStorage: FavoritesStorageProtocol
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController,
         persistenceController: PersistenceControllerProtocol,
         favoritesStorage: FavoritesStorageProtocol) {
        self.navigationController = navigationController
        self.persistenceController = persistenceController
        self.favoritesStorage = favoritesStorage
    }

    func start() {
        let viewModel = FavoritesViewModel(storage: favoritesStorage)
        let favoritesVC = FavoritesViewController(viewModel: viewModel)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)

        viewModel.didSelectRepo
            .sink { [weak self] repo in
                self?.showDetail(for: repo)
            }
            .store(in: &cancellables)

        navigationController.setViewControllers([favoritesVC], animated: false)
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
