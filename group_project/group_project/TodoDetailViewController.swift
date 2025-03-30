//
//  TodoDetailViewController.swift
//  group_project
//
//  Created by Aadi Badola on 2025-02-27.
//

import UIKit

extension UITextView {
    func applyStyle() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
    }
}

class TodoDetailViewController: UIViewController {
    
    @IBOutlet weak var todoCategoryView: UITextView!
    @IBOutlet weak var todoStatusView: UITextView!
    @IBOutlet weak var todoNotesView: UITextView!
    @IBOutlet weak var todoTitleView: UITextView!
    @IBOutlet weak var todoDueView: UITextView!
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if presentedViewController == nil {
            performSegue(withIdentifier: "editTodoSegue", sender: nil)
        }
    }
    var todoItem: TodoItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyles()
        
        if let item = todoItem {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let dueDateString = formatter.string(from: item.dueDate)
            
            todoTitleView.attributedText = formatText(label: "Title:", value: item.title)
            todoNotesView.attributedText = formatText(label: "Notes:", value: item.notes)
            todoStatusView.attributedText = formatText(label: "Status:", value: item.status.rawValue)
            todoCategoryView.attributedText = formatText(label: "Category:", value: item.category)
            todoDueView.attributedText = formatText(label: "Due Date:", value: dueDateString)
        }
    }
    
    private func formatText(label: String, value: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: "\(label) ",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]
        )
        let valueString = NSAttributedString(
            string: value,
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        )
        attributedString.append(valueString)
        return attributedString
    }
    
    func setStyles() {
        todoTitleView.applyStyle()
        todoNotesView.applyStyle()
        todoStatusView.applyStyle()
        todoCategoryView.applyStyle()
        todoDueView.applyStyle()
        
        todoTitleView.isEditable = false
        todoNotesView.isEditable = false
        todoStatusView.isEditable = false
        todoCategoryView.isEditable = false
        todoDueView.isEditable = false
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let item = todoItem else { return }
        
        TodoDataManager.shared.removeTodoItem(item)
        navigationController?.popViewController(animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "editTodoSegue" {
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTodoSegue",
           let addTodoVC = segue.destination as? AddTodoViewController {
            
            guard let item = todoItem else { return }
            
            addTodoVC.isEditingTodo = true
            addTodoVC.todoItemToEdit = item
            addTodoVC.defaultCategory = item.category
            addTodoVC.allCategories = TodoDataManager.shared.categories
        }
    }
    
}
