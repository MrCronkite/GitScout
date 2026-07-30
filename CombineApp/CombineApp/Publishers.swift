//
//  Publishers.swift
//  CombineApp
//
//  Created by Admin on 28.07.24.
//

import UIKit
import Combine

class NetworkService {
    func fetchData() -> AnyPublisher<String, Never> {

            Future { promise in
                print("🌐 Making network request...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    promise(.success("server response"))
                }
            }
            .eraseToAnyPublisher()
    }
}

class ViewModel {
    let service = NetworkService()
    var cancellables = Set<AnyCancellable>()

    func loadTwice() {
        let publisher = service.fetchData().share()

        publisher
            .sink { print("Subscriber 1 got:", $0) }
            .store(in: &cancellables)

        publisher
            .sink { print("Subscriber 2 got:", $0) }
            .store(in: &cancellables)
    }
}
