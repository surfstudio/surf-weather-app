//
//  CoreDataStack.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import Foundation
import CoreData

protocol CoreDataStack {
    var container: NSPersistentContainer {get}
}

final class ModernCoreDataStack: CoreDataStack {

    // MARK: - Constants

    private enum Constants {
        static let dataBaseName = "StorageDataBase"
    }

    // MARK: - CoreDataStack

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.dataBaseName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("something went wrong \(error) \(error.userInfo)")
            }
        }
        return container
    }()

}
