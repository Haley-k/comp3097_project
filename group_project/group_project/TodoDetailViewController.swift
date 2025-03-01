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
    
    
    @IBOutlet weak var todoStatusView: UITextView!
    @IBOutlet weak var todoNotesView: UITextView!
    @IBOutlet weak var todoTitleView: UITextView!
    @IBOutlet weak var todoDueView: UITextView!
    
    var todoTitle: String?
    var todoDue: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStyles()
        todoDueView?.text = todoDue
        todoTitleView?.text = todoTitle
        
    }
    
    func setStyles() {
        todoTitleView.applyStyle()
        todoNotesView.applyStyle()
        todoStatusView.applyStyle()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editTodoSegue" {
            if let destinationVC = segue.destination as? AddTodoViewController {
                // preset text fields...
            }
        }
    }

}
