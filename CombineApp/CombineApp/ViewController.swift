//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit
import Combine

struct User: Decodable {
    let id: Int
    let name: String
}

struct Post: Decodable {
    let id: Int
    let title: String
}


class RegistrationForm {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published private(set) var isSubmitEnabled: Bool = false

    init() {
        Publishers.CombineLatest3(
            $email,
            $password,
            $confirmPassword
        )
        .map { email, password, confirmPassword in
            let emailValid = email.contains("@") && email.contains(".")
            let passwordValid = password.count >= 8
            let passwordsMatch = password == confirmPassword
            return emailValid && passwordValid && passwordsMatch
        }
        .assign(to: &$isSubmitEnabled)
    }
}


final class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!

    let registr = RegistrationForm()

    override func viewDidLoad() {
        super.viewDidLoad()

        registr.email = "1232@.re"
        registr.password = "12345678"
        registr.confirmPassword = "12345678"

        print(registr.isSubmitEnabled)

    }
}
