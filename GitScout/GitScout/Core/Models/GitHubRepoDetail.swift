//
//  GitHubRepoDetail.swift
//  GitScout
//
//  Created by Влад Шимченко on 24.08.2026.
//

import Foundation

// GitHubRepoDetail.swift
struct GitHubRepoDetail: Decodable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let language: String?
    let defaultBranch: String
    let htmlUrl: String
    let owner: GitHubRepo.Owner
    let license: License?

    struct License: Decodable {
        let name: String
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description, language, owner, license
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case defaultBranch = "default_branch"
        case htmlUrl = "html_url"
    }
}
