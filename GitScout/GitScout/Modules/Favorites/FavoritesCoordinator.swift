//
//  FavoritesCoordinator.swift
//  GitScout
//
//  Created by Влад Шимченко on 25.08.2026.
//

import UIKit


final class FavoritesCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let persistenceController: PersistenceControllerProtocol

    init(navigationController: UINavigationController, persistenceController: PersistenceControllerProtocol) {
        self.navigationController = navigationController
        self.persistenceController = persistenceController
    }

    func start() {
        let placeholderVC = UIViewController()
        placeholderVC.view.backgroundColor = .systemBackground
        placeholderVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        navigationController.setViewControllers([placeholderVC], animated: false)
    }
}
