//
//  ExperementalView.swift
//  CombineApp
//
//  Created by Влад Шимченко on 23.07.2026.
//

import UIKit

struct User: Decodable {
    let id: Int
    let name: String
}

final class ExperementalView {

    init() {}

    func start() async {
        let task = Task {
            do {
                let users = try await fetchUsers(ids: ["1", "2", "3", "4", "5"])
                print(users)
            } catch is CancellationError {
                print("cancelation")
            } catch {
                print(error.localizedDescription)
            }
        }

        try? await Task.sleep(for: .milliseconds(500))

        task.cancel()
    }

    func fetchUsers(ids: [String]) async throws -> [User] {

        var users = Array<User?>(repeating: nil, count: ids.count)

        try await withThrowingTaskGroup(of: (Int, User).self) { [weak self] group in
            guard let self else { throw CancellationError() }

            for (index, id) in ids.enumerated() {
                group.addTask {
                    let user = try await self.fetchUser(id)
                    return (index, user)
                }
            }

            for try await (index, user) in group {
                users[index] = user
            }
        }

        return users.compactMap { $0 }

    }

    func fetchUser(_ id: String) async throws -> User {
        try Task.checkCancellation()

        try await Task.sleep(for: .milliseconds(500))

        try Task.checkCancellation()

        return User(id: Int(id) ?? 0, name: "nil")
    }
}
