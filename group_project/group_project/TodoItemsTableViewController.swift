//
//  TodoItemsTableViewController.swift
//  group_project
//
//  Created by Aadi Badola on 2025-02-26.
//

import UIKit

protocol AddTodoDelegate: AnyObject {
    func didAddTodo(item: TodoItem)
}

class TodoItemsTableViewController: UITableViewController, UISearchBarDelegate, AddTodoDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var titleTextView: UITextView!
    
    var isSearchActive: Bool = false
    var filteredItems: [TodoItem] = []
    var categoryName: String?
    
    let statusSections: [TodoStatus] = TodoStatus.allCases
    
    var itemsByStatus: [TodoStatus: [TodoItem]] {
        guard let category = categoryName else { return [:] }
        let allItems = TodoDataManager.shared.getTodoItems(for: category)
        return Dictionary(grouping: allItems, by: { $0.status })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        if let catName = categoryName {
            titleTextView?.text = catName
            navigationItem.title = catName
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - SearchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let category = categoryName else { return }
        if searchText.isEmpty {
            isSearchActive = false
        } else {
            isSearchActive = true
            let allItems = TodoDataManager.shared.getTodoItems(for: category)
            filteredItems = allItems.filter {
                $0.title.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableView.reloadData()
    }
    
    // MARK: - AddTodoDelegate
    
    func didAddTodo(item: TodoItem) {
        TodoDataManager.shared.addTodoItem(item)
        tableView.reloadData()
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActive ? 1 : statusSections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchActive ? "Search Results" : statusSections[section].rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return filteredItems.count
        } else {
            let status = statusSections[section]
            return itemsByStatus[status]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let todoItem: TodoItem
        if isSearchActive {
            todoItem = filteredItems[indexPath.row]
        } else {
            let status = statusSections[indexPath.section]
            todoItem = itemsByStatus[status]?[indexPath.row] ?? TodoItem(title: "", dueDate: Date(), notes: "", status: .pending, category: "")
        }
        
        cell.textLabel?.text = todoItem.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dueDateString = formatter.string(from: todoItem.dueDate)
        
        let today = Date()
        let calendar = Calendar.current
        let daysRemaining = calendar.dateComponents([.day], from: today, to: todoItem.dueDate).day ?? 0
        
        let dueDateColor: UIColor = {
            if daysRemaining < 0 {
                return .red
            } else if daysRemaining < 3 {
                return .blue
            } else {
                return .gray
            }
        }()
        
        let attributedText = NSMutableAttributedString(string: "Due: ", attributes: [.foregroundColor: UIColor.black])
        let dueDateAttr = NSAttributedString(string: dueDateString, attributes: [.foregroundColor: dueDateColor])
        attributedText.append(dueDateAttr)
        cell.detailTextLabel?.attributedText = attributedText
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTodoDetailSegue",
           let detailVC = segue.destination as? TodoDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow,
           let catName = categoryName {
            
            let item: TodoItem
            if isSearchActive {
                item = filteredItems[indexPath.row]
            } else {
                let status = statusSections[indexPath.section]
                item = itemsByStatus[status]?[indexPath.row] ?? TodoItem(title: "", dueDate: Date(), notes: "", status: .pending, category: "")
            }
            detailVC.todoItem = item
        } else if segue.identifier == "newTodoSegue",
                  let addTodoVC = segue.destination as? AddTodoViewController {
            addTodoVC.delegate = self
            addTodoVC.allCategories = TodoDataManager.shared.categories
            addTodoVC.defaultCategory = categoryName
        }
    }
    
    @IBAction func unwindToTodoItemsTableViewController(_ segue: UIStoryboardSegue) {}
}
