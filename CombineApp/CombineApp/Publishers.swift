//
//  Publishers.swift
//  CombineApp
//
//  Created by Admin on 28.07.24.
//

import UIKit
import Combine

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "1"

    private let weatherService: WeatherService
    private var cancellables = Set<AnyCancellable>()

    init(weatherService: WeatherService) {
        self.weatherService = weatherService

        Publishers.Zip3(
            weatherService.agePublisher,
            weatherService.cityPublisher,
            weatherService.namePublisher
        ).sink {
           print("B:", $0, $1, $2)
        }
        .store(in: &cancellables)

        Publishers.CombineLatest3(
            weatherService.agePublisher,
            weatherService.cityPublisher,
            weatherService.namePublisher
        ).sink {
           print("A:", $0, $1, $2)
        }
        .store(in: &cancellables)

        Publishers.MergeMany(
            weatherService.agePublisher.map(String.init).eraseToAnyPublisher(),
            weatherService.cityPublisher.eraseToAnyPublisher(),
            weatherService.namePublisher.eraseToAnyPublisher()
        ).sink {
            print("C:", $0)
        }
        .store(in: &cancellables)
    }
}

class WeatherService {
    let namePublisher = PassthroughSubject<String, Never>()
    let agePublisher = PassthroughSubject<Int, Never>()
    let cityPublisher = PassthroughSubject<String, Never>()
}
