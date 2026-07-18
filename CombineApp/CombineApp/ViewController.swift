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


final class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserPosts(userId: 1)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")

                case .failure(let error):
                    print("Error:", error.localizedDescription)
                }
            } receiveValue: { posts in
                print(posts)
            }
            .store(in: &subscriptions)
    }

    func fetchUserPosts(userId: Int) -> AnyPublisher<[Post], Error> {
         fetchUser(id: userId)
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] user -> AnyPublisher<[Post], Error> in
                guard let self else {
                    return Fail(
                        error: URLError(.cancelled)
                    )
                    .eraseToAnyPublisher()
                }
                return self.fetchPosts(userId: user.id)
            }
            .eraseToAnyPublisher()
    }

    func fetchUser(id: Int) -> AnyPublisher<User, Error> {
        let url = URL(string: "https://api.example.com/users/\(id)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchPosts(userId: Int) -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://api.example.com/users/\(userId)/posts")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
