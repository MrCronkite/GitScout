//
//  AppCoordinator.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import UIKit
import Combine

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let interactor = SearchInteractor()
        let searchViewModel = SearchViewModel(interactor: interactor)
        let searchVC = SearchViewController(viewModel: searchViewModel)

        searchViewModel.didSelectRepo
            .sink { [weak self] repo in
                self?.showDetail(for: repo)
            }
            .store(in: &cancellables)

        navigationController.setViewControllers([searchVC], animated: false)
    }

    private func showDetail(for repo: GitHubRepo) {
        let interactor = DetailInteractor()
        let viewModel = DetailViewModel(repo: repo, interactor: interactor)
        let detailVC = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}
