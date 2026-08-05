//
//  ViewModel.swift
//  CombineApp
//
//  Created by Admin on 26.07.24.
//

import UIKit
import Combine
import pthread


actor StatusCollector {
    private var statuses: [String: String] = [:]

    func record(_ id: String, status: String) {
        statuses[id] = status
    }

    func snapshot() -> [String: String] {
        statuses
    }
}

enum Event {
    case stop
}

final class UsersViewModel {

    let statusCollect = StatusCollector()

    init() {
        Task {
        }
    }

    func checkServerStatus(id: String) async throws -> String {
        let delay = Double.random(in: 0.5...3.0)
        try await Task.sleep(for: .seconds(delay))
        try Task.checkCancellation()
        return "OK"
    }

    func collectStatuses(ids: [String]) async -> [String: String] {

        let stream = AsyncStream<Event> { continuation in
            Task {
                try? await Task.sleep(for: .seconds(2))
                continuation.yield(.stop)
                continuation.finish()
            }
        }

        await withTaskGroup(of: Void.self) { group in

            group.addTask {

                await withTaskGroup(of: Void.self) { statusGroup in

                    for id in ids {
                        statusGroup.addTask {
                            do {
                                let status = try await self.checkServerStatus(id: id)

                                await self.statusCollect.record(
                                    id,
                                    status: status
                                )
                            } catch {
                                print(error)
                            }
                        }
                    }

                    await statusGroup.waitForAll()
                }
            }

            group.addTask {

                for await event in stream {

                    if event == .stop {
                        print("Timeout")

                        group.cancelAll()
                        break
                    }
                }
            }

            await group.waitForAll()
        }

        return await statusCollect.snapshot()
    }
}
