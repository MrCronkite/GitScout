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

    private let interactor: DetailInteractorProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repo: GitHubRepo, interactor: DetailInteractorProtocol) {
        self.initialRepo = repo
        self.interactor = interactor
        fetchDetails()
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
