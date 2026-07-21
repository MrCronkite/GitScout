//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit
import Combine

struct User: Decodable {
    let id: Int
    let name: String
}

final class NetworkApi {

    func search(_ query: String) -> AnyPublisher<[User], Error> {

        let url = URL(
            string: "https://api.example.com/users?q=\(query)"
        )!

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(
                type: [User].self,
                decoder: JSONDecoder()
            )
            .eraseToAnyPublisher()
    }
}

enum TimeoutError: Error {
    case exceeded
}


final class ViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!

    var subscriptions = Set<AnyCancellable>()

    let vm = UsersViewModel(api: NetworkApi())

    let searchSubject = PassthroughSubject<String, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            // Тест 1: успех
            print("Test 1: Fast operation")
            do {
                let result = try await operationWithTimeout(timeout: .seconds(1)) {
                    try await Task.sleep(for: .milliseconds(100))
                    return "Success"
                }
                print("Result: \(result)")  // Success
            } catch {
                print("Error: \(error)")
            }

            // Тест 2: timeout
            print("\nTest 2: Slow operation")
            do {
                let result = try await operationWithTimeout(timeout: .milliseconds(100)) {
                    try await Task.sleep(for: .seconds(1))
                    return "Success"
                }
                print("Result: \(result)")
            } catch is TimeoutError {
                print("Timeout!")  // Timeout!
            }
        }

    }

    func operationWithTimeout<T>(
        timeout: Duration,
        operation: @escaping () async throws -> T
    ) async throws -> T {


        return try await withThrowingTaskGroup(of: T.self) { group in

            group.addTask {
                return try await operation()
            }

            group.addTask {
                try await Task.sleep(for: timeout)
                throw TimeoutError.exceeded
            }

            do {
                guard let result = try await group.next() else {
                    throw TimeoutError.exceeded
                }

                group.cancelAll()
                return result
            } catch is TimeoutError {
                group.cancelAll()
                throw TimeoutError.exceeded
            }
        }
    }
}
