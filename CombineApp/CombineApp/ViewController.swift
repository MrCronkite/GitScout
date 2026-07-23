//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit

final class ViewController: UIViewController {

    private let ev = ExperementalView()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await ev.start()
        }

    }
}
