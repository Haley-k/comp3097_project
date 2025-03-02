//
//  AddTodoListViewController.swift
//  group_project
//
//  Created by Haley Kim on 2025-02-26.
//

import UIKit

protocol AddItemDelegate: AnyObject {
    func didAddNewItem(_ item: String)
}

class AddTodoListViewController: UIViewController {

    @IBOutlet weak var todoListTextField: UITextField!
    
    weak var delegate: AddItemDelegate?
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if let newItem = todoListTextField.text, !newItem.isEmpty {
            delegate?.didAddNewItem(newItem)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
