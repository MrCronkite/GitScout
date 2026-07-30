//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    private let ev = ExperementalView()

    let prices = PassthroughSubject<Double, Never>()
    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        prices
            .map { $0 * 1.2 }
            .filter { $0 > 100 }
            .sink { print($0) }
            .store(in: &cancellable)

        Task {
            await ev.start()
        }

        prices.send(50)
        prices.send(90)
        prices.send(150)
        prices.send(80)
    }
}
