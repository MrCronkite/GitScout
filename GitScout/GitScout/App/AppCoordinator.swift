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
    private let tabBarController = UITabBarController()

    private var searchCoordinator: SearchCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?

    init(window: UIWindow, persistenceController: PersistenceControllerProtocol) {
        self.window = window
        self.persistenceController = persistenceController
    }

    func start() {
        let searchNav = UINavigationController()
        let favoritesNav = UINavigationController()

        let searchCoordinator = SearchCoordinator(navigationController: searchNav, persistenceController: persistenceController)
        let favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNav, persistenceController: persistenceController)

        self.searchCoordinator = searchCoordinator
        self.favoritesCoordinator = favoritesCoordinator

        searchCoordinator.start()
        favoritesCoordinator.start()

        tabBarController.viewControllers = [searchNav, favoritesNav]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
