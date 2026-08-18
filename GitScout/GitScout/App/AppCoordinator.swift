//
//  AppCoordinator.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}


final class AppCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let interactor = SearchInteractor()
        let viewModel = SearchViewModel(interactor: interactor)
        let searchVC = SearchViewController(viewModel: viewModel)
        navigationController.setViewControllers([searchVC], animated: false)
    }
}
