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
        do {
            let user = try await fetchUser(id: "1")
            print(user)
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchUser(id: String) async throws -> User {

        guard let url = URL(string: "https://api.example/users/\(id)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode(User.self, from: data)
    }

}
