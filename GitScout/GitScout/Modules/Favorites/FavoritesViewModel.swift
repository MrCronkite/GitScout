//
//  FavoritesViewModel.swift
//  GitScout
//
//  Created by Влад Шимченко on 26.08.2026.
//

import Foundation
import Combine

@MainActor
final class FavoritesViewModel {
    @Published private(set) var items: [RepoCellModel] = []
    let didSelectRepo = PassthroughSubject<GitHubRepo, Never>()

    private let storage: FavoritesStorageProtocol
    private var cancellables = Set<AnyCancellable>()

    init(storage: FavoritesStorageProtocol) {
        self.storage = storage
        bind()
    }

    private func bind() {
        storage.favoritesPublisher
            .map { favorites in favorites.map(RepoCellModel.init(favorite:)) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.items = items
            }
            .store(in: &cancellables)
    }

    func select(_ item: RepoCellModel) {
        didSelectRepo.send(item.repo)
    }
}
