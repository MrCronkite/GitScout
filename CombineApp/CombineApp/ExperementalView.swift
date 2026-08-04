//
//  ExperementalView.swift
//  CombineApp
//
//  Created by Влад Шимченко on 23.07.2026.
//

import SwiftUI
import Combine

class FlakyService {
    private var attemptCount = 0

    func request() -> AnyPublisher<String, Error> {
        attemptCount += 1
        let currentAttempt = attemptCount
        print("Attempt #\(currentAttempt)")

        if currentAttempt < 3 {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            return Just("Success!")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}


final class ExperementalView {

    let service = FlakyService()
    var cancellables = Set<AnyCancellable>()

    let events = PassthroughSubject<String, Never>()
    let start = Date()

    init() {}

    func elapsed() -> String {
        String(format: "%.2fs", Date().timeIntervalSince(start))
    }

    func start() async {
        events
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .sink { value in
                print("Received: \(value) at t=\(self.elapsed())")
            }
            .store(in: &cancellables)

        Task {
            print("send 'first' at t=\(elapsed())")
            events.send("first")

            try? await Task.sleep(for: .seconds(1))
            print("send 'second' at t=\(elapsed())")
            events.send("second")

            try? await Task.sleep(for: .seconds(0.5))
            print("send 'third' at t=\(elapsed())")
            events.send("third")
        }

    }
}
