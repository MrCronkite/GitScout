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

    let email = CurrentValueSubject<String, Never>("")
    let password = CurrentValueSubject<String, Never>("")
    let agreedToTerms = CurrentValueSubject<Bool, Never>(false)

    let deposits = PassthroughSubject<Double, Never>()

    init() {}


    func start() async {
        func observePrices() async {
            for await price in deposits.values {
                print("Price:", price)
                if price > 100 {
                    print("Price exceeded threshold, stopping")
                    break
                }
            }
            print("Loop ended")
        }

        Task {
            await observePrices()

            try? await Task.sleep(for: .seconds(3))

            deposits.send(50)
            deposits.send(80)
            deposits.send(150)
            deposits.send(30)
        }
    }

    func fetchUserPublisher(id: String) -> AnyPublisher<String, Error> {
        Deferred {
            Future { promise in
                Task {
                    do {
                        let user = try await self.fetchUserAsync(id: id)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchUserAsync(id: String) async throws -> String {
        try await Task.sleep(for: .seconds(1))
        return "User \(id)"
    }
}
