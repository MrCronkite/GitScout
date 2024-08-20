//
//  FibanachiPublisher.swift
//  CombineApp
//
//  Created by Admin on 30.07.24.
//

import Combine

enum FibanachiError: Error {
    case intOverflow
}

struct FibanachiPublisher: Publisher {
    
    typealias Output = Int
    typealias Failure = FibanachiError
    
    func receive<S>(subscriber: S) where S : Subscriber, FibanachiError == S.Failure, Int == S.Input {
        let subscription = FibanachiSubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }

}


class FibanachiSubscription<S: Subscriber>: Subscription where S.Input == Int, FibanachiError == S.Failure {
    
    private var subscriber: S?
    private var current = 0
    private var next = 1
    
    init(subscriber: S) {
        self.subscriber = subscriber
    }
    
    func request(_ demand: Subscribers.Demand) {
        var remainingDemand = demand
        
        while remainingDemand > .none {
            guard let subscriber = subscriber else { return }
            
            // Отправляем текущее значение подписчику
            let nextDemand = subscriber.receive(current)
            remainingDemand -= 1
            remainingDemand += nextDemand
            
            // Вычисляем следующее число Фибоначчи
            let newNext = current.addingReportingOverflow(next)
            if newNext.overflow {
                subscriber.receive(completion: .failure(FibanachiError.intOverflow))
                return
            } else {
                current = next
                next = newNext.partialValue
            }
        }
        
        // Если больше нет спроса, завершаем подписку
        if remainingDemand == .none {
            subscriber?.receive(completion: .finished)
        }
    }
    
    func cancel() {
        subscriber = nil
    }
}
