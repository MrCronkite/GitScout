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


    override func viewDidLoad() {
        super.viewDidLoad()

       publisher.sink
        {
            print("Completed: \($0)")
        } receiveValue: {
            print("Value: \($0)")
        }
        .store(in: &subscriptions)
    }
}
