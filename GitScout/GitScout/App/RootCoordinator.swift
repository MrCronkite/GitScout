//
//  RootCoordinator.swift
//  GitScout
//
//  Created by Влад Шимченко on 26.08.2026.
//


import UIKit

final class RootCoordinator: Coordinator {
    private let window: UIWindow
    private let persistenceController: PersistenceControllerProtocol
    private var appCoordinator: AppCoordinator?

    init(window: UIWindow, persistenceController: PersistenceControllerProtocol) {
        self.window = window
        self.persistenceController = persistenceController
    }

    func start() {
        let splashVC = SplashViewController()
        window.rootViewController = splashVC
        window.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.showMainFlow()
        }
    }

    private func showMainFlow() {
        let coordinator = AppCoordinator(window: window, persistenceController: persistenceController)
        appCoordinator = coordinator
        coordinator.start()
    }
}
