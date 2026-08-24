//
//  GitHubRepo.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import Foundation

struct GitHubSearchResponse: Decodable {
    let totalCount: Int
    let items: [GitHubRepo]

    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }
}

struct GitHubRepo: Decodable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let language: String?
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case id, name, description, language, owner
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
    }

    struct Owner: Decodable, Hashable {
        let login: String
        let avatarUrl: String

        enum CodingKeys: String, CodingKey {
            case login
            case avatarUrl = "avatar_url"
        }
    }
}
