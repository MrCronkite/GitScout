//
//  ExperementalView.swift
//  CombineApp
//
//  Created by Влад Шимченко on 23.07.2026.
//

import UIKit

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

final class ExperementalView {

    init() {}

    func start() async {
        do {
            try await consumeScores()
        } catch is TimeoutError {
            print("TimeoutError")
        } catch {
            print("error")
        }
    }

    func consumeScores() async throws {
        var iterator = liveScores().makeAsyncIterator()

        while true {
            let next = try await withThrowingTaskGroup(of: Int?.self) { group -> Int? in
                group.addTask { await iterator.next() }
                group.addTask {
                    try await Task.sleep(for: .seconds(5))
                    throw TimeoutError()
                }

                defer { group.cancelAll() }
                return try await group.next() ?? nil

            }

            guard let score = next else { break }
            print("Score:", score)
        }
    }

    func liveScores() -> AsyncStream<Int> {
        AsyncStream { continuation in
            let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                continuation.yield(Int.random(in: 0...100))
            }
            continuation.onTermination = { _ in
                timer.invalidate()
            }
        }
    }

}
