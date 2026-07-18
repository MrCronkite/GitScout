//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit
import Combine

class TemperatureMonitor {
    @Published var celsius: Double = 0

    private var cancellable = Set<AnyCancellable>()

    init() {
        $celsius
            .map { $0 * 9 / 5 + 32 }
            .filter { $0 > 100 }
            .sink {
                 print("Внимание! Слишком жарко: \($0)°F")
            }
            .store(in: &cancellable)

    }
}


final class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!

    let temp = TemperatureMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()

        temp.celsius = 40 

    }
}
