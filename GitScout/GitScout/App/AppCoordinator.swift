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
    private let window: UIWindow
    private let persistenceController: PersistenceControllerProtocol
    private let favoritesStorage: FavoritesStorageProtocol
    private let tabBarController = UITabBarController()

    private var searchCoordinator: SearchCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?

    init(window: UIWindow, persistenceController: PersistenceControllerProtocol) {
        self.window = window
        self.persistenceController = persistenceController
        self.favoritesStorage = FavoritesStorage(persistenceController: persistenceController)
    }

    func start() {
        let searchNav = UINavigationController()
        let favoritesNav = UINavigationController()

        let searchCoordinator = SearchCoordinator(
            navigationController: searchNav,
            persistenceController: persistenceController,
            favoritesStorage: favoritesStorage
        )

        let favoritesCoordinator = FavoritesCoordinator(
            navigationController: favoritesNav,
            persistenceController: persistenceController,
            favoritesStorage: favoritesStorage
        )

        self.searchCoordinator = searchCoordinator
        self.favoritesCoordinator = favoritesCoordinator

        searchCoordinator.start()
        favoritesCoordinator.start()

        tabBarController.viewControllers = [searchNav, favoritesNav]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
