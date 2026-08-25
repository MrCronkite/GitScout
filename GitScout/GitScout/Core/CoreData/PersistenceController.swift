//
//  PersistenceController.swift
//  GitScout
//
//  Created by Влад Шимченко on 25.08.2026.
//

import CoreData
import Foundation


protocol PersistenceControllerProtocol {
    var viewContext: NSManagedObjectContext { get }
    func newBackgroundContext() -> NSManagedObjectContext
    func saveContext(_ context: NSManagedObjectContext) throws
}


final class PersistenceController: PersistenceControllerProtocol {
    private let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        let model = GitScoutModel.makeManagedObjectModel()
        container = NSPersistentContainer(name: "GitScout", managedObjectModel: model)

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        container.newBackgroundContext()
    }

    func saveContext(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
