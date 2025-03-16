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
    
    var filteredItems: [TodoItem] = []
    var isSearchActive: Bool = false
    var categoryName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        if let catName = categoryName {
            titleTextView?.text = catName;
            navigationItem.title = catName
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let catName = categoryName else { return }
        
        if searchText.isEmpty {
            isSearchActive = false
        } else {
            isSearchActive = true
            filteredItems = TodoDataManager.shared.getTodoItems(for: catName).filter {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func didAddTodo(item: TodoItem) {
        TodoDataManager.shared.addTodoItem(item)
        dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let catName = categoryName else { return 0 }
        return isSearchActive ? filteredItems.count : TodoDataManager.shared.getTodoItems(for: catName).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        guard let catName = categoryName else { return cell }
        
        let todoItem = isSearchActive ? filteredItems[indexPath.row] : TodoDataManager.shared.getTodoItems(for: catName)[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dueDateString = formatter.string(from: todoItem.dueDate)
        
        let today = Date()
        let calendar = Calendar.current
        let daysRemaining = calendar.dateComponents([.day], from: today, to: todoItem.dueDate).day ?? 0
        
        let dueDateColor: UIColor = {
            if daysRemaining < 0 {
                return .red // past due
            } else if daysRemaining < 3 {
                return .blue // due in 3 days
            }
            else {
                return .gray // defult
            }
        }()
        
        let attributedText = NSMutableAttributedString(string: "Due: ", attributes: [.foregroundColor: UIColor.black])
        let dueDateAttributedString = NSAttributedString(string: dueDateString, attributes: [.foregroundColor: dueDateColor])
        attributedText.append(dueDateAttributedString)
        
        cell.textLabel?.text = todoItem.title
        cell.detailTextLabel?.attributedText = attributedText
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTodoDetailSegue" {
            if let detailVC = segue.destination as? TodoDetailViewController,
               
                let index = tableView.indexPathForSelectedRow?.row,
               let catName = categoryName {
                let items = TodoDataManager.shared.getTodoItems(for: catName)
                detailVC.todoItem = items[index]
            }
        }
        else if segue.identifier == "newTodoSegue",
                let addTodoVC = segue.destination as? AddTodoViewController {
            addTodoVC.delegate = self
            addTodoVC.allCategories = TodoDataManager.shared.categories
            addTodoVC.defaultCategory = categoryName
        }
    }
    
    @IBAction func unwindToTodoItemsTableViewController(_ segue: UIStoryboardSegue) {
        
    }
}

