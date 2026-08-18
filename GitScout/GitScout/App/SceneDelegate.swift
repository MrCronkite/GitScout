//
//  SceneDelegate.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController()

        let coordinator = AppCoordinator(navigationController: navController)
        appCoordinator = coordinator
        coordinator.start()

        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
    }
}
