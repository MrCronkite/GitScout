//
//  ExperementalView.swift
//  CombineApp
//
//  Created by Влад Шимченко on 23.07.2026.
//

import SwiftUI
import Combine

struct TimeoutError: Error {}

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

struct User {
    let id: Int
    let name: String
}

final class ExperementalView {

    init() {}

    func start() async {
        do {
            let users = try await fetchAllUsers(ids: ["1", "2", "3", "4", "5", "6"])
            print(users)
        } catch is CancellationError {
            print("CancellationError")
        } catch {
            print(error.localizedDescription)
        }
    }


    func fetchAllUsers(ids: [String]) async throws -> [User] {
        var users = Array<User?>(repeating: nil, count: ids.count)

        let queue = AsyncStream<(Int, String)> { continuation in
            for item in ids.enumerated() {
                continuation.yield(item)
            }

            continuation.finish()
        }

        try await withThrowingTaskGroup(of: Void.self) { group in
           for _ in 0..<3 {
                group.addTask {
                    for await (index, id) in queue {
                        let user = try await self.fetchUser(id)

                        users[index] = user
                     }
                }
            }

           try await group.waitForAll()
        }

        return users.compactMap { $0 }
    }

    func fetchUser(_ id: String) async throws -> User {
        try Task.checkCancellation()

        try? await Task.sleep(for: .seconds(0.5))

        try Task.checkCancellation()

        return User(id: Int(id) ?? 0, name: "Vlad \(id)")
    }

}
