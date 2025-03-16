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
        guard let title = todoTitleTextField.text, !title.isEmpty else {
            return
        }
        
        guard let category = selectedCategory else {
            return
        }
        
        let dueDate = todoDueDateField.date
        let notes = todoNotesTextField.text ?? ""
        
        if isEditingTodo, let oldItem = todoItemToEdit {
            // edit
            let updatedItem = TodoItem(title: title, dueDate: dueDate, notes: notes, status: selectedStatus, category: category)
            TodoDataManager.shared.updateTodoItems(for: oldItem.category, items: TodoDataManager.shared.getTodoItems(for: oldItem.category).filter { $0.title != oldItem.title } + [updatedItem])
        } else {
            // new item
            let newItem = TodoItem(title: title, dueDate: dueDate, notes: notes, status: selectedStatus, category: category)
            delegate?.didAddTodo(item: newItem)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
