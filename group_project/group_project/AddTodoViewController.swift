//
//  AddTodoViewController.swift
//  group_project
//
//  Created by Aadi Badola on 2025-02-26.
//

import UIKit

protocol AddTodoDelegate: AnyObject {
    func didAddTodo(title: String, dueDate: String)
}

class AddTodoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var categoriesView: UIPickerView!
    
    @IBOutlet weak var todoStatusTextField: UITextField!
    @IBOutlet weak var todoNotesTextField: UITextField!
    
    @IBOutlet weak var todoTitleTextField: UITextField!
    @IBOutlet weak var todoDueDateField: UIDatePicker!
    
    var todoTitle: String?
    var todoDueDate: String?
    var todoCategory: String?
    
    let categories = ["Home", "Work", "Personal" ]
    
    weak var delegate: AddTodoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoriesView.delegate = self
        categoriesView.dataSource = self
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        todoCategory = categories[row]
    }
    
    @IBAction func addTodoButtonTapped(_ sender: UIButton) {
        guard let title = todoTitleTextField.text, !title.isEmpty else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dueDate = dateFormatter.string(from: todoDueDateField.date)
        
        delegate?.didAddTodo(title: title, dueDate: dueDate)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "unwindAddTodo" {
            if let title = todoTitleTextField.text, !title.isEmpty {
                todoTitle = title
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                todoDueDate = formatter.string(from: todoDueDateField.date)
            }
        }
    }

}
