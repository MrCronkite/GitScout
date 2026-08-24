//
//  DetailInteractor.swift
//  GitScout
//
//  Created by Влад Шимченко on 24.08.2026.
//

import Combine
import Foundation


protocol DetailInteractorProtocol {
    func fetchDetails(owner: String, repoName: String) -> AnyPublisher<GitHubRepoDetail, Error>
}

final class DetailInteractor: DetailInteractorProtocol {
    private let session: URLSession
    private let decoder = JSONDecoder()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchDetails(owner: String, repoName: String) -> AnyPublisher<GitHubRepoDetail, Error> {
        guard let url = URL(string: "https://api.github.com/repos/\(owner)/\(repoName)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitHubRepoDetail.self, decoder: decoder)
            .mapError { error -> Error in
                if error is DecodingError { return NetworkError.decoding(error) }
                return NetworkError.server(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
