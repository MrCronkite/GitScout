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
    var cancellable = Set<AnyCancellable>()

    init() {}

    func start() async {
        service.request()
            .retry(3)
            .sink(
                receiveCompletion: { print("Completion:", $0) },
                receiveValue: { print("Value:", $0) }
            )
            .store(in: &cancellable)
    }
}
