//
//  FavoritesStorage.swift
//  GitScout
//
//  Created by Влад Шимченко on 26.08.2026.
//

import Foundation
import CoreData
import Combine

protocol FavoritesStorageProtocol {
    var favoritesPublisher: AnyPublisher<[FavoriteRepo], Never> { get }
    func add(_ repo: GitHubRepo)
    func remove(id: Int)
    func isFavorite(id: Int) -> Bool
}

final class FavoritesStorage: NSObject, FavoritesStorageProtocol {
    private let persistenceController: PersistenceControllerProtocol
    private let subject = CurrentValueSubject<[FavoriteRepo], Never>([])
    private var fetchedResultsController: NSFetchedResultsController<FavoriteRepo>?

    var favoritesPublisher: AnyPublisher<[FavoriteRepo], Never> {
        subject.eraseToAnyPublisher()
    }

    init(persistenceController: PersistenceControllerProtocol) {
        self.persistenceController = persistenceController
        super.init()
        setupFetchedResultsController()
    }

    private func setupFetchedResultsController() {
        let request = NSFetchRequest<FavoriteRepo>(entityName: "FavoriteRepo")
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]

        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistenceController.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        fetchedResultsController = controller

        do {
            try controller.performFetch()
            subject.send(controller.fetchedObjects ?? [])
        } catch {
            print("Failed to fetch favorites: \(error)")
        }
    }

    func add(_ repo: GitHubRepo) {
        let context = persistenceController.viewContext
        let favorite = FavoriteRepo(context: context)
        favorite.id = Int64(repo.id)
        favorite.name = repo.name
        favorite.ownerLogin = repo.owner.login
        favorite.avatarUrl = repo.owner.avatarUrl
        favorite.repoDescription = repo.description
        favorite.stargazersCount = Int64(repo.stargazersCount)
        favorite.language = repo.language
        favorite.dateAdded = Date()

        save(context)
    }

    func remove(id: Int) {
        let context = persistenceController.viewContext
        let request = NSFetchRequest<FavoriteRepo>(entityName: "FavoriteRepo")
        request.predicate = NSPredicate(format: "id == %d", id)

        if let objects = try? context.fetch(request) {
            objects.forEach { context.delete($0) }
            save(context)
        }
    }

    func isFavorite(id: Int) -> Bool {
        subject.value.contains { $0.id == Int64(id) }
    }

    private func save(_ context: NSManagedObjectContext) {
        do {
            try persistenceController.saveContext(context)
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }
}

extension FavoritesStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let favorites = controller.fetchedObjects as? [FavoriteRepo] else { return }
        subject.send(favorites)
    }
}
