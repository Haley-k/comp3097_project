//
//  TodoItemsTableViewController.swift
//  group_project
//
//  Created by Aadi Badola on 2025-02-26.
//

import UIKit

class TodoItemsTableViewController: UITableViewController, AddTodoDelegate {

    @IBOutlet weak var titleTextView: UITextView!
    
    var todoTitle: String?
    var todoItems: [(title: String, dueDate: String)] = [
        ("Todo 1", "Due: March 1, 2025"),
        ("Todo 2", "Due: March 5, 2025"),
        ("Todo 3", "Due: March 10, 2025")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        titleTextView?.textContainer.maximumNumberOfLines = 1
        titleTextView?.textContainer.lineBreakMode = .byTruncatingTail
        if let title = todoTitle {
            titleTextView?.text = title;
            self.navigationItem.title = title;
            self.title = title;
        }
        
    }
    
    func didAddTodo(title: String, dueDate: String) {
        todoItems.append((title, dueDate))
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        // Configure the cell...
        let todoItem = todoItems[indexPath.row]
        cell.textLabel?.text = todoItem.title
        cell.detailTextLabel?.text = todoItem.dueDate

        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTodoDetailSegue" {
            if let destinationVC = segue.destination as? TodoDetailViewController,
               let selectedRow = tableView.indexPathForSelectedRow?.row {
                   destinationVC.todoTitle = todoItems[selectedRow].title
                   destinationVC.todoDue = todoItems[selectedRow].dueDate
               }
        }
        if segue.identifier == "newTodoSegue",
           let addTodoVC = segue.destination as? AddTodoViewController {
                addTodoVC.delegate = self
        }
    }
    
    @IBAction func unwindToTodoItemsTableViewController(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? AddTodoViewController, let newTitle = sourceVC.todoTitle, let newTodoDue = sourceVC.todoDueDate {
            todoItems.append((title: newTitle, dueDate: newTodoDue))
            tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}
