//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    private let ev = ExperementalView()
    private let vm = UsersViewModel()


    private var cancellable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await ev.start()
        }

    }
}
