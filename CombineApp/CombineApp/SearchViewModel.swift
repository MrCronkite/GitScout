//
//  SearchViewModel.swift
//  CombineApp
//
//  Created by Влад Шимченко on 27.07.2026.
//

import Foundation
import Combine

class SearchViewModel {
    @Published var searchText: String = ""

    @Published private(set) var result: [String] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        bindSearch()
    }

    private func bindSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map { [weak self] query in
                self?.performSearch(query: query)
                ?? Just([]).eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.result = result
            }
            .store(in: &cancellables)
    }

    func performSearch(query: String) -> AnyPublisher<[String], Never> {

        Just(["result for \(query)"])
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
