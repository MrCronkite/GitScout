//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit

final class ViewController: UIViewController {

    private let ev = ExperementalView()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await ev.start()
        }

        let services = WeatherService()

        let vm = WeatherViewModel(weatherService: services)

        services.namePublisher.send("Alice")
        services.agePublisher.send(25)
        services.namePublisher.send("Bob")
        services.cityPublisher.send("Berlin")
        services.agePublisher.send(30)
        services.cityPublisher.send("Munich")


    }
}
