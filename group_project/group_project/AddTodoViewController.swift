//
//  AddTodoViewController.swift
//  group_project
//
//  Created by Aadi Badola on 2025-02-26.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var statusPickerView: UIPickerView!
    @IBOutlet weak var categoriesPickerView: UIPickerView!
    @IBOutlet weak var todoNotesTextField: UITextField!
    @IBOutlet weak var todoTitleTextField: UITextField!
    @IBOutlet weak var todoDueDateField: UIDatePicker!
    
    weak var delegate: AddTodoDelegate?
    
    var allCategories: [String] = []
    var defaultCategory: String?
    
    var isEditingTodo = false
    var todoItemToEdit: TodoItem?
    
    private let statuses = TodoStatus.allCases
    private var selectedStatus: TodoStatus = .pending
    private var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryPicker()
        setupStatusPicker()
        setupDefaults()
        todoTitleTextField.addTarget(self, action: #selector(titleTextChanged), for: .editingChanged)
    }
    
    @objc func titleTextChanged(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func setupCategoryPicker() {
        categoriesPickerView.delegate = self
        categoriesPickerView.dataSource = self
    }
    
    private func setupStatusPicker() {
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
    }
    
    private func setupDefaults() {
        if let item = todoItemToEdit {
            todoTitleTextField.text = item.title
            todoNotesTextField.text = item.notes
            todoDueDateField.date = item.dueDate
            selectedStatus = item.status
            selectedCategory = item.category
        } else {
            selectedCategory = defaultCategory ?? allCategories.first
            selectedStatus = .pending
        }
        if let selectedIndex = allCategories.firstIndex(of: selectedCategory ?? "") {
            categoriesPickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        if let statusIndex = statuses.firstIndex(of: selectedStatus) {
            statusPickerView.selectRow(statusIndex, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func addTodoButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        guard let title = todoTitleTextField.text, !title.isEmpty else {
            todoTitleTextField.layer.borderColor = UIColor.red.cgColor
            todoTitleTextField.layer.borderWidth = 1.0
            todoTitleTextField.layer.cornerRadius = 5
            
            let alert = UIAlertController(title: "Missing Title",
                                          message: "Please enter a title for your to-do item.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                sender.isEnabled = true
            }))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        
        guard let category = selectedCategory else {
            sender.isEnabled = true
            return
        }
        
        let dueDate = todoDueDateField.date
        let notes = todoNotesTextField.text ?? ""
        
        if isEditingTodo, let oldItem = todoItemToEdit {
            if oldItem.category != category {
                TodoDataManager.shared.moveTodoItem(oldItem, to: category)
            } else {
                let updatedItem = TodoItem(title: title, dueDate: dueDate, notes: notes, status: selectedStatus, category: category)
                let updatedItems = TodoDataManager.shared.getTodoItems(for: oldItem.category).filter { $0.title != oldItem.title } + [updatedItem]
                TodoDataManager.shared.updateTodoItems(for: oldItem.category, items: updatedItems)
            }
        } else {
            let newItem = TodoItem(title: title, dueDate: dueDate, notes: notes, status: selectedStatus, category: category)
            delegate?.didAddTodo(item: newItem)
        }
        
        dismissOrPop(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismissOrPop(animated: true)
    }
    
    private func dismissOrPop(animated: Bool) {
        if let nav = navigationController {
            if let todoItemsVC = nav.viewControllers.first(where: { $0 is TodoItemsTableViewController }) {
                nav.popToViewController(todoItemsVC, animated: animated)
            } else {
                nav.popViewController(animated: animated)
            }
        } else {
            dismiss(animated: animated, completion: nil)
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension AddTodoViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == categoriesPickerView {
            return allCategories.count
        } else {
            return statuses.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView == categoriesPickerView {
            return allCategories[row]
        } else {
            return statuses[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == categoriesPickerView {
            selectedCategory = allCategories[row]
        } else {
            selectedStatus = statuses[row]
        }
    }
}
