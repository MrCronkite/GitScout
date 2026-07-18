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

    let a = PassthroughSubject<Int, Never>()
    let b = PassthroughSubject<String, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let cancellabel = Publishers.Zip(a, b)
            .sink { number, text in
                print("\(number) - \(text)")
            }

        a.send(1)
        b.send("A")
        a.send(2)
        b.send("B")
        a.send(3)
    }
}
