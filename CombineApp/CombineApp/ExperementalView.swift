//
//  ExperementalView.swift
//  CombineApp
//
//  Created by Влад Шимченко on 23.07.2026.
//

import SwiftUI
import Combine

struct Temperature {
    let celsius: Double
}


final class ExperementalView {

    let counter = PassthroughSubject<Int, Never>()
    var cancellable = Set<AnyCancellable>()

    init() {}

    func start() async {
        counter.sink { print("Sub 1:", $0) }.store(in: &cancellable)

        counter.send(1)
        counter.send(2)

        counter.sink { print("Sub 2:", $0) }.store(in: &cancellable)

        counter.send(3)
    }
}
