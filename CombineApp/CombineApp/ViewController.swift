//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit
import Combine

struct Config: Decodable {
    let featureFlags: [String: Bool]
}


final class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchConfigSafely()
            .sink { completion in
                print(completion.featureFlags)
            }
            .store(in: &subscriptions)

    }

    func fetchConfigSafely() -> AnyPublisher<Config, Never> {
        fetchConfig()
            .retry(2)
            .catch { error in
                Just(Config(featureFlags: [:]))
            }
            .eraseToAnyPublisher()
    }

    func fetchConfig() -> AnyPublisher<Config, URLError> {
        let url = URL(string: "https://api.example.com/config")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Config.self, decoder: JSONDecoder())
            .mapError { error -> URLError in
                error as? URLError ?? URLError(.unknown)
            }
            .eraseToAnyPublisher()
    }
}
