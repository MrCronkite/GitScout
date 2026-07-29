//
//  ProfileViewModel.swift
//  CombineApp
//
//  Created by Влад Шимченко on 27.07.2026.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false

    private var currentTask: Task<Void, Never>?

    func loadProfile(id: String) {
        currentTask?.cancel()
        isLoading = true

        currentTask = Task {
            let user = try? await fetchUser(id: id)

            guard !Task.isCancelled else { return }

            self.user = user
            self.isLoading = false
        }
    }

    func fetchUser(id: String) async throws -> User {
        try await Task.sleep(for: .seconds(1))
        return User(id: Int(id) ?? 0, name: "User \(id)")
    }
}
