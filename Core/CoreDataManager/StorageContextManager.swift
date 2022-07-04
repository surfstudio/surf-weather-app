//
//  StorageContextManager.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import CoreData

final class StorageContextManager {
    
    static let shared = StorageContextManager()

    let context: NSManagedObjectContext

    private init() {
        let coreDataStack = ModernCoreDataStack()
        context = coreDataStack.container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

}
