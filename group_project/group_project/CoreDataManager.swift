//
//  CoreDataManager.swift
//  group_project
//
//  Created by Haley Kim on 2025-04-05.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "TodoModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving Core Data: \(error.localizedDescription)")
            }
        }
    }

    func deleteAllData(entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Error deleting Core Data: \(error.localizedDescription)")
        }
    }
}
