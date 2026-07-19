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

final class NetworkApi {

    func search(_ query: String) -> AnyPublisher<[User], Error> {

        let url = URL(
            string: "https://api.example.com/users?q=\(query)"
        )!

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(
                type: [User].self,
                decoder: JSONDecoder()
            )
            .eraseToAnyPublisher()
    }
}


final class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!

    var subscriptions = Set<AnyCancellable>()

    let subject = CurrentValueSubject<Int, Never>(0)

    let vm = UsersViewModel(api: NetworkApi())

    override func viewDidLoad() {
        super.viewDidLoad()

        vm.query = "234"

        print(vm.error)
        print(vm.users)

    }
}
