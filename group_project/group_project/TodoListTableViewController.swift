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
                let selectedCategory = TodoDataManager.shared.categories[selectedRow]
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
}
