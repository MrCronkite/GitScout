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

        weatherService.temperaturePublisher
            .map { "\($0)°C" }
            .sink { [weak self] temperature in
                print(temperature)
                self?.temperature = temperature
            }
            .store(in: &cancellables)
    }
}

class WeatherService {
    let temperaturePublisher = PassthroughSubject<Double, Never>()

    func updateTemperature(_ value: Double) {
        temperaturePublisher.send(value)
    }
}
