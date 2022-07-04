//
//  CoreDataRepository.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import Combine
import CoreData

enum RepositoryError: Error {
    case objectNotFound
}

protocol StorageManager {
    associatedtype Entity: NSManagedObject

    func objects() -> AnyPublisher<[Entity], Error>
    func add(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error>
    func update(_ entity: Entity) -> AnyPublisher<Void, Error>
    func delete(_ entity: Entity) -> AnyPublisher<Void, Error>
}

final class CoreDataRepository<Entity: NSManagedObject>: StorageManager {

    let context = StorageContextManager.shared.context

    func object(_ id: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    guard let entity = try? context.existingObject(with: id) as? Entity else {
                        promise(.failure(RepositoryError.objectNotFound))
                        return
                    }
                    promise(.success(entity))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func objects() -> AnyPublisher<[Entity], Error> {
        Deferred { [context] in
            Future { promise in
                let request = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
                context.perform {
                    guard let entities = try? context.fetch(request) else {
                        promise(.failure(RepositoryError.objectNotFound))
                        return
                    }
                    promise(.success(entities))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func add(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future  { promise in
                context.perform {
                    var entity = Entity(context: context)
                    body(&entity)
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func update(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    do {
                        try context.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func delete(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    do {
                        context.delete(entity)
                        try context.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

}
