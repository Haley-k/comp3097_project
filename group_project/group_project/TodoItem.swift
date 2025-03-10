//
//  TodoItem.swift
//  group_project
//
//  Created by Haley Kim on 2025-03-08.
//

import Foundation

struct TodoItem {
    let title: String
    let dueDate: Date
    let notes: String
    let status: TodoStatus
    let category: String // In which list category
}

enum TodoStatus: String, CaseIterable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    case cancelled = "Cancelled"
}
