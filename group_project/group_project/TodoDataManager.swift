//
//  TodoDataManager.swift
//  group_project
//
//  Created by Haley Kim on 2025-03-08.
//

import Foundation
import CoreData

class TodoDataManager {
    static let shared = TodoDataManager()
    
    private init() {}
    
    private var context: NSManagedObjectContext {
        CoreDataManager.shared.context
    }
    
    // MARK: - Categories
    
    var categories: [String] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["name"]
        request.returnsDistinctResults = true
        
        if let result = try? context.fetch(request) as? [[String: Any]] {
            return result.compactMap { $0["name"] as? String }
        }
        return []
    }
    
    func addCategory(_ newCategory: String) {
        guard !newCategory.isEmpty else { return }
        
        // Check if category already exists
        if categories.contains(newCategory) { return }
        
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context)
        category.setValue(newCategory, forKey: "name")
        
        CoreDataManager.shared.saveContext()
    }
    
    func renameCategory(from oldName: String, to newName: String) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Category")
        request.predicate = NSPredicate(format: "name == %@", oldName)
        
        if let result = try? CoreDataManager.shared.context.fetch(request), let category = result.first {
            category.setValue(newName, forKey: "name")
            CoreDataManager.shared.saveContext()
        }
    }
    
    func removeCategory(_ name: String) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Category")
        request.predicate = NSPredicate(format: "name == %@", name)
        
        if let result = try? CoreDataManager.shared.context.fetch(request), let category = result.first {
            CoreDataManager.shared.context.delete(category)
            CoreDataManager.shared.saveContext()
        }
    }
    
    
    // MARK: - TodoItem
    
    func addTodoItem(_ item: TodoItem) {
        // Fetch or create category
        let categoryRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        categoryRequest.predicate = NSPredicate(format: "name == %@", item.category)
        let category: NSManagedObject
        
        if let result = try? context.fetch(categoryRequest), let existing = result.first {
            category = existing
        } else {
            category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context)
            category.setValue(item.category, forKey: "name")
        }
        
        // Add Todo
        let todo = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)
        todo.setValue(item.title, forKey: "title")
        todo.setValue(item.dueDate, forKey: "dueDate")
        todo.setValue(item.notes, forKey: "notes")
        todo.setValue(item.status.rawValue, forKey: "status")
        todo.setValue(category, forKey: "category")
        
        CoreDataManager.shared.saveContext()
    }
    
    func getTodoItems(for category: String) -> [TodoItem] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        request.predicate = NSPredicate(format: "category.name == %@", category)
        
        let result = try? context.fetch(request)
        return result?.compactMap { todo in
            guard
                let title = todo.value(forKey: "title") as? String,
                let dueDate = todo.value(forKey: "dueDate") as? Date,
                let notes = todo.value(forKey: "notes") as? String,
                let statusRaw = todo.value(forKey: "status") as? String,
                let status = TodoStatus(rawValue: statusRaw)
            else { return nil }
            
            return TodoItem(title: title, dueDate: dueDate, notes: notes, status: status, category: category)
        } ?? []
    }
    
    func updateTodoItems(for category: String, items: [TodoItem]) {
        let existingItems = getTodoItems(for: category)
        for item in existingItems {
            removeTodoItem(item)
        }
        for item in items {
            addTodoItem(item)
        }
    }
    
    func removeTodoItem(_ item: TodoItem) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Todo")
        request.predicate = NSPredicate(format: "title == %@ AND category.name == %@", item.title, item.category)
        
        if let result = try? context.fetch(request), let todo = result.first {
            context.delete(todo)
            CoreDataManager.shared.saveContext()
        }
    }
    
    func moveTodoItem(_ item: TodoItem, to newCategory: String) {
        removeTodoItem(item)
        
        let movedItem = TodoItem(
            title: item.title,
            dueDate: item.dueDate,
            notes: item.notes,
            status: item.status,
            category: newCategory
        )
        
        addTodoItem(movedItem)
    }
}
