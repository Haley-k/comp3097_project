//
//  AddTodoListViewController.swift
//  group_project
//
//  Created by Haley Kim on 2025-02-26.
//

import UIKit

class AddTodoListViewController: UIViewController {
    
    var onCategoryAdded: (() -> Void)?
    
    @IBOutlet weak var todoListTextField: UITextField!
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let newCategory = todoListTextField.text, !newCategory.isEmpty else { return }
        
        TodoDataManager.shared.addCategory(newCategory)
        onCategoryAdded?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
