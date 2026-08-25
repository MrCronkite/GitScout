//
//  FavoriteRepo.swift
//  GitScout
//
//  Created by Влад Шимченко on 25.08.2026.
//

import Foundation
import CoreData

@objc(FavoriteRepo)
final class FavoriteRepo: NSManagedObject {
    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var ownerLogin: String
    @NSManaged var avatarUrl: String
    @NSManaged var repoDescription: String?
    @NSManaged var stargazersCount: Int64
    @NSManaged var language: String?
    @NSManaged var dateAdded: Date
}
