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

actor Counter {
    var counter = 0

    func updateCounter() async {
        for _ in 0..<20000 {
            counter += 1
        }
    }
}

struct UserProfile {
    let id: Int
    let name: String
    let email: String
}

enum UserFetchError: Error {
    case notFound
    case networkError
}

actor UserProfileFetcher {
    private var cache: [Int: UserProfile] = [:]
    private var loadingUsers: [Int: Task<UserProfile, Error>] = [:]
    
    func fetchProfile(userId: Int) async throws -> UserProfile {
        // Если в кэше → вернуть сразу
        if let profile = cache[userId] {
            return profile
        }
        
        defer { loadingUsers.removeValue(forKey: userId) }
        
        if let task = loadingUsers[userId] {
            return try await task.value
        }
        
        
        let task = Task { try await downloadProfile(userId: userId) }
        loadingUsers[userId] = task
        let profile = try await task.value
        cache[userId] = profile
        return profile
    }
    
    private func downloadProfile(userId: Int) async throws -> UserProfile {
        try await Task.sleep(for: .milliseconds(400))
        
        if userId == 999 {
            throw UserFetchError.notFound
        }
        
        return UserProfile(
            id: userId,
            name: "User_\(userId)",
            email: "user\(userId)@example.com"
        )
    }
}


final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            let fetcher = UserProfileFetcher()

            print("Test 1: 5 concurrent requests for same user")
            let startTime = Date()

            await withTaskGroup(of: Void.self) { group in
                for i in 0..<5 {
                    group.addTask {
                        do {
                            let profile = try await fetcher.fetchProfile(userId: 1)
                            print("Request \(i): ✅ \(profile.name)")
                        } catch {
                            print("Request \(i): ❌ \(error)")
                        }
                    }
                }
            }

            let elapsed = Date().timeIntervalSince(startTime)
            print("Time: \(String(format: "%.2f", elapsed))s (expected ~0.4s)\n")

            print("Test 2: Different users (should download separately)")
            await withTaskGroup(of: Void.self) { group in
                for userId in [2, 3, 2, 3] {  // две пары одинаковых
                    group.addTask {
                        do {
                            let profile = try await fetcher.fetchProfile(userId: userId)
                            print("User \(userId): ✅ \(profile.name)")
                        } catch {
                            print("User \(userId): ❌ \(error)")
                        }
                    }
                }
            }

            print("\nTest 3: Not found error")
            do {
                _ = try await fetcher.fetchProfile(userId: 999)
            } catch is UserFetchError {
                print("✅ Correctly threw error for userId 999")
            }
        }
    }
}
