//
//  NetworkError.swift
//  GitScout
//
//  Created by Влад Шимченко on 26.08.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case decoding(Error)
    case server(Error)
}
