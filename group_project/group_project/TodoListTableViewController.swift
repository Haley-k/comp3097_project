//
//  TodoListTableViewController.swift
//  group_project
//
//  Created by Haley Kim on 2025-02-26.
//

import UIKit

class TodoListTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredCategories: [String] = []
    var isSearchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearchActive = false
        } else {
            isSearchActive = true
            filteredCategories = TodoDataManager.shared.categories.filter {
                $0.lowercased().contains(searchText.lowercased())
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
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearchActive ? filteredCategories.count : TodoDataManager.shared.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        let category = isSearchActive ? filteredCategories[indexPath.row] : TodoDataManager.shared.categories[indexPath.row]
        cell.textLabel?.text = category
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTodoItemsSegue" {
            if let itemsVC = segue.destination as? TodoItemsTableViewController,
               let selectedRow = tableView.indexPathForSelectedRow?.row {
                let selectedCategory = isSearchActive
                ? filteredCategories[selectedRow]
                : TodoDataManager.shared.categories[selectedRow]
                
                itemsVC.categoryName = selectedCategory
            }
        }
        
        else if segue.identifier == "addTodoListSegue" {
            if let addListVC = segue.destination as? AddTodoListViewController {
                addListVC.onCategoryAdded = { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        // deleting
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let categoryToDelete = self.isSearchActive ? self.filteredCategories[indexPath.row] : TodoDataManager.shared.categories[indexPath.row]
            
            if let index = TodoDataManager.shared.categories.firstIndex(of: categoryToDelete) {
                TodoDataManager.shared.removeCategory(categoryToDelete)
            }
            if self.isSearchActive {
                self.filteredCategories.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        
        // editing
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            let oldCategory = self.isSearchActive ? self.filteredCategories[indexPath.row] : TodoDataManager.shared.categories[indexPath.row]
            
            let alert = UIAlertController(title: "Edit Category", message: "Enter new category name", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.text = oldCategory
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
                if let newCategory = alert.textFields?.first?.text, !newCategory.isEmpty {
                    
                    if let index = TodoDataManager.shared.categories.firstIndex(of: oldCategory) {
                        TodoDataManager.shared.renameCategory(from: oldCategory, to: newCategory)
                    }
                    
                    if self.isSearchActive {
                        self.filteredCategories[indexPath.row] = newCategory
                    }
                    
                    self.tableView.reloadData()
                }
            }))
            self.present(alert, animated: true)
            
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
