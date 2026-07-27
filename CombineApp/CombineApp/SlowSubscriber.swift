//
//  SlowSubscriber.swift
//  CombineApp
//
//  Created by Влад Шимченко on 27.07.2026.
//

import Foundation
import Combine

final class SlowSubscriber: Subscriber {

    typealias Input = Int
    typealias Failure = Never

    private var subscription: Subscription?
    private var receivedCount = 0

    func receive(subscription: any Subscription) {
        print("Subscribed")

        self.subscription = subscription

        subscription.request(.max(1))
    }

    func receive(_ input: Int) -> Subscribers.Demand {
        receivedCount += 1

        print("Receved \(input)")

        Thread.sleep(forTimeInterval: 1)

        if receivedCount == 5 {
            print("Cancel")
            subscription?.cancel()
            return .none
        }

        subscription?.request(.max(1))

        return .none
    }

    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed: \(completion)")
    }
}
