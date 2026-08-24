//
//  RepoCellModel.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import Foundation

// RepoCellModel.swift — UI-модель, отдельно от сырого ответа API
struct RepoCellModel: Hashable {
    let repo: GitHubRepo
    let id: Int
    let name: String
    let ownerName: String
    let avatarUrl: URL?
    let description: String
    let stars: String
    let language: String?

    init(repo: GitHubRepo) {
        self.repo = repo
        self.id = repo.id
        self.name = repo.name
        self.ownerName = repo.owner.login
        self.avatarUrl = URL(string: repo.owner.avatarUrl)
        self.description = repo.description ?? "No description"
        self.stars = Self.formatStars(repo.stargazersCount)
        self.language = repo.language
    }

    private static func formatStars(_ count: Int) -> String {
        if count >= 1000 {
            return String(format: "%.1fk", Double(count) / 1000)
        }
        return "\(count)"
    }
}
