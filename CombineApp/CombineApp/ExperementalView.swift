//
//  ExperementalView.swift
//  CombineApp
//
//  Created by Влад Шимченко on 23.07.2026.
//

import UIKit

final class ExperementalView {

    init() {}

    func start() async {
        let users = await fetchUsers(ids: [1, 2, 3, 4, 5])
        print(users)
    }

    func fetchUser(id: Int) async -> String {
        try? await Task.sleep(for: .seconds(1))
        return "User \(id)"
    }

    func fetchUsers(ids: [Int]) async -> [String] {
        var users = Array(repeating: "", count: ids.count)

        await withTaskGroup(of: (Int, String).self) { group in

            for (index, id) in ids.enumerated() {
                group.addTask {
                    (index, await self.fetchUser(id: id))
                }
            }

            while let (index, user) = await group.next() {
                users[index] = user
            }
        }

        return users

    }
}
