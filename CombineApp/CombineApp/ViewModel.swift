//
//  ViewModel.swift
//  CombineApp
//
//  Created by Admin on 26.07.24.
//

import UIKit
import Combine

final class UsersViewModel {

    private var subscriptions = Set<AnyCancellable>()

    @Published var query = ""

    @Published var users: [User] = []

    @Published var error: Error?

    private let api: NetworkApi


    init(api: NetworkApi) {
        self.api = api

        $query
            .debounce(
                for: .milliseconds(500),
                scheduler: DispatchQueue.main
            )
            .removeDuplicates()
            .flatMap { query in
                self.api.search(query)
                    .catch { error -> Just<[User]> in
                        self.error = error
                        return Just([])
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink { users in
                self.users = users
            }
            .store(in: &subscriptions)
    }
}
