//
//  SceneDelegate.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var rootCoordinator: RootCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let persistenceController = PersistenceController()
        let coordinator = RootCoordinator(window: window, persistenceController: persistenceController)
        rootCoordinator = coordinator
        coordinator.start()
    }
}
