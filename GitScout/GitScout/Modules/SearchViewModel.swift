//
//  SearchViewModel.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import Foundation
import Combine

// SearchViewModel.swift
enum SearchViewState {
    case idle
    case loading
    case loaded([RepoCellModel])
    case empty
    case error(String)
}

final class SearchViewModel {
    let searchSubject = PassthroughSubject<String, Never>()
    @Published private(set) var state: SearchViewState = .idle

    private let interactor: SearchInteractorProtocol
    private var cancellables = Set<AnyCancellable>()

    init(interactor: SearchInteractorProtocol) {
        self.interactor = interactor
        bind()
    }

    private func bind() {
        searchSubject
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] query in
                if !query.isEmpty {
                    self?.state = .loading
                }
            })
            .flatMap { [weak self] query -> AnyPublisher<SearchViewState, Never> in
                guard let self else { return Just(.idle).eraseToAnyPublisher() }
                guard !query.isEmpty else {
                    return Just(.idle).eraseToAnyPublisher()
                }
                return self.interactor.search(query: query)
                    .map { repos -> SearchViewState in
                        let cellModels = repos.map(RepoCellModel.init)
                        return cellModels.isEmpty ? .empty : .loaded(cellModels)
                    }
                    .catch { error in
                        Just(SearchViewState.error(error.localizedDescription))
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                self?.state = newState
            }
            .store(in: &cancellables)
    }
}
