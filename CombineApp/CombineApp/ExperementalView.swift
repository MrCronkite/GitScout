//
//  ExperementalView.swift
//  CombineApp
//
//  Created by Влад Шимченко on 23.07.2026.
//

import SwiftUI
import Combine


final class ExperementalView {

    let numbers = [10, 20, 30].publisher
    var cancellable = Set<AnyCancellable>()

    init() {}

    func start() async {
        numbers.sink(
            receiveCompletion: { print("Completion:", $0) } ,
            receiveValue: { print("Value:", $0) }
        )
        .store(in: &cancellable)
    }
}
