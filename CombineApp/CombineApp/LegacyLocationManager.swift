//
//  LegacyLocationManager.swift
//  CombineApp
//
//  Created by Влад Шимченко on 27.07.2026.
//

import Foundation

struct CLLocation {
    let latitude: Double
    let longitude: Double
}

class LegacyLocationManager {
    func requestLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        // где-то внутри вызывает completion ровно один раз... а иногда — два :)
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(.success(CLLocation(latitude: 55.75, longitude: 37.61)))
        }
    }
}

extension LegacyLocationManager {
    func loaction() async throws -> CLLocation {
        try await withCheckedThrowingContinuation { continuation in

            let lock = NSLock()
            var resumed = false

            requestLocation { result in
                lock.lock()
                defer { lock.unlock() }

                guard !resumed else { return }
                resumed = true

                continuation.resume(with: result)
            }
        }
    }
}
