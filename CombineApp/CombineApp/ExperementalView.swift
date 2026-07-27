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

actor ImageCache {
    private var cache: [String: UIImage] = [:]
    private var loadingImages: [String: Task<UIImage, Error>] = [:]

    func image(for key: String) async throws -> UIImage? {
        if let cached = cache[key] {
            return cached
        }

        if let task = loadingImages[key] {
            return try await task.value
        }

        let task = Task {
            guard let url = URL(string: key) else { throw URLError(.badURL) }

            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }

            return image
        }

        loadingImages[key] = task

        defer { loadingImages[key] = nil }
        
        let valueImage = try await task.value
        cache[key] = valueImage
        return valueImage
    }
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
