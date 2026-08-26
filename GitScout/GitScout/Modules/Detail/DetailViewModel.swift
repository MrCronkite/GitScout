//
//  DetailViewModel.swift
//  GitScout
//
//  Created by Влад Шимченко on 24.08.2026.
//

import Foundation
import Combine


enum DetailViewState {
    case loading
    case loaded(GitHubRepoDetail)
    case error(String)
}

final class DetailViewModel {
    let initialRepo: GitHubRepo
    @Published private(set) var state: DetailViewState = .loading
    @Published private(set) var isFavorite: Bool

    private let interactor: DetailInteractorProtocol
    private let favoritesStorage: FavoritesStorageProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repo: GitHubRepo, interactor: DetailInteractorProtocol, favoritesStorage: FavoritesStorageProtocol) {
        self.initialRepo = repo
        self.interactor = interactor
        self.favoritesStorage = favoritesStorage
        self.isFavorite = favoritesStorage.isFavorite(id: repo.id)
        fetchDetails()
        observeFavoritesChanges()
    }

    private func observeFavoritesChanges() {
        favoritesStorage.favoritesPublisher
            .map { [weak self] _ in
                guard let self else { return false }
                return self.favoritesStorage.isFavorite(id: self.initialRepo.id)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFav in
                self?.isFavorite = isFav
            }
            .store(in: &cancellables)
    }

    func toggleFavorite() {
        if isFavorite {
            favoritesStorage.remove(id: initialRepo.id)
        } else {
            favoritesStorage.add(initialRepo)
        }
    }

    private func fetchDetails() {
        interactor.fetchDetails(owner: initialRepo.owner.login, repoName: initialRepo.name)
            .map { DetailViewState.loaded($0) }
            .catch { Just(DetailViewState.error($0.localizedDescription)) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.state = state
            }
            .store(in: &cancellables)
    }
}
