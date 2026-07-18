//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit
import Combine


final class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!


    let publisher = Just(42)
    var subscriptions = Set<AnyCancellable>()
    let subject = PassthroughSubject<Int, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let future = futureIncrement(integer: 1, delay: 3)

        future.sink {
            print($0)
        } receiveValue: {
            print($0)
        }
        .store(in: &subscriptions)


        subject.send(1)

        let cancellable = subject.sink { value in
            print("Получено: \(value)")
        }

        subject.send(2)
        subject.send(3)

    }

    func futureIncrement(integer: Int, delay: TimeInterval) -> Future<Int, Never> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(integer + 1))
            }
        }
    }
}
