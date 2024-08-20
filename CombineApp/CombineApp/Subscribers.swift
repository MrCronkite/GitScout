//
//  Subscribers.swift
//  CombineApp
//
//  Created by Admin on 20.08.24.
//

import Combine



final class SubscribersData {

    var subs: Set<AnyCancellable> = Set()

    let data: Array<Int> = [1, 2, 3, 4, 5, 6, 78, 2]

    func sinkData() { 
        let publisher = data.publisher

        publisher.sink { completion in
            switch completion {
            case .finished:
                print("Succesfully fin")
            case .failure(let error):
                print("Completion error: \(error)")
            }
        } receiveValue: { value in
            print("current value: \(value)")
        }.store(in: &subs)
    }
}
