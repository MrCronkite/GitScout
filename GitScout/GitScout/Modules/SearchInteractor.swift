//
//  SearchInteractor.swift
//  GitScout
//
//  Created by Влад Шимченко on 18.08.2026.
//

import Foundation
import Combine

// SearchInteractor.swift
protocol SearchInteractorProtocol {
    func search(query: String) -> AnyPublisher<[GitHubRepo], Error>
}

enum NetworkError: Error {
    case invalidURL
    case decoding(Error)
    case server(Error)
}

final class SearchInteractor: SearchInteractorProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func search(query: String) -> AnyPublisher<[GitHubRepo], Error> {
        guard let url = buildURL(query: query) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitHubSearchResponse.self, decoder: decoder)
            .map(\.items)
            .mapError { error -> Error in
                if error is DecodingError {
                    return NetworkError.decoding(error)
                }
                return NetworkError.server(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func buildURL(query: String) -> URL? {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        var components = URLComponents(string: "https://api.github.com/search/repositories")
        components?.queryItems = [URLQueryItem(name: "q", value: query)]
        return components?.url
    }
}
