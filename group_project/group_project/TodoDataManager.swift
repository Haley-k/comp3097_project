//
//  TodoDataManager.swift
//  group_project
//
//  Created by Haley Kim on 2025-03-08.
//

import Foundation

class TodoDataManager {
    static let shared = TodoDataManager()
    
    private init() {}
    
    var categories: [String] = []
    var itemsByCategory: [String: [TodoItem]] = [:]
    
    func addCategory(_ newCategory: String) {
        guard !newCategory.isEmpty else { return }
        
        if !categories.contains(newCategory) {
            categories.append(newCategory)
            itemsByCategory[newCategory] = []
        }
    }
    
    func addTodoItem(_ item: TodoItem) {
        if !categories.contains(item.category) {
            categories.append(item.category)
            itemsByCategory[item.category] = []
        }
        itemsByCategory[item.category]?.append(item)
    }
    
    func getTodoItems(for category: String) -> [TodoItem] {
        return itemsByCategory[category] ?? []
    }
    
    func updateTodoItems(for category: String, items: [TodoItem]) {
        itemsByCategory[category] = items
    }
    
    func removeTodoItem(_ item: TodoItem) {
        if var items = itemsByCategory[item.category] {
            if let index = items.firstIndex(where: { $0.title == item.title }) {
                items.remove(at: index)
                itemsByCategory[item.category] = items
            }
        }
    }
}
