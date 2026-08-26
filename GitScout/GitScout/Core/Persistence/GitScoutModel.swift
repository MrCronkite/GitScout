//
//  GitScoutModel.swift
//  GitScout
//
//  Created by Влад Шимченко on 25.08.2026.
//

import Foundation
import CoreData

enum GitScoutModel {
    static func makeManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "FavoriteRepo"
        entity.managedObjectClassName = NSStringFromClass(FavoriteRepo.self)

        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .integer64AttributeType
        idAttr.isOptional = false

        let nameAttr = NSAttributeDescription()
        nameAttr.name = "name"
        nameAttr.attributeType = .stringAttributeType
        nameAttr.isOptional = false

        let ownerLoginAttr = NSAttributeDescription()
        ownerLoginAttr.name = "ownerLogin"
        ownerLoginAttr.attributeType = .stringAttributeType
        ownerLoginAttr.isOptional = false

        let avatarUrlAttr = NSAttributeDescription()
        avatarUrlAttr.name = "avatarUrl"
        avatarUrlAttr.attributeType = .stringAttributeType
        avatarUrlAttr.isOptional = false

        let repoDescriptionAttr = NSAttributeDescription()
        repoDescriptionAttr.name = "repoDescription"
        repoDescriptionAttr.attributeType = .stringAttributeType
        repoDescriptionAttr.isOptional = true

        let stargazersCountAttr = NSAttributeDescription()
        stargazersCountAttr.name = "stargazersCount"
        stargazersCountAttr.attributeType = .integer64AttributeType
        stargazersCountAttr.isOptional = false

        let languageAttr = NSAttributeDescription()
        languageAttr.name = "language"
        languageAttr.attributeType = .stringAttributeType
        languageAttr.isOptional = true

        let dateAddedAttr = NSAttributeDescription()
        dateAddedAttr.name = "dateAdded"
        dateAddedAttr.attributeType = .dateAttributeType
        dateAddedAttr.isOptional = false

        entity.properties = [
            idAttr, nameAttr, ownerLoginAttr, avatarUrlAttr,
            repoDescriptionAttr, stargazersCountAttr, languageAttr, dateAddedAttr
        ]

        model.entities = [entity]
        return model
    }
}
