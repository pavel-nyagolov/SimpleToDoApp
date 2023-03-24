//
//  CreateTaskViewController.swift
//  SimpleToDoApp
//
//  Created by Pavel on 20.03.23.
//

import UIKit
import RealmSwift

class CreateTaskViewController: UIViewController {

    @IBOutlet weak var taskTitleField: UITextField!
    @IBOutlet weak var taskDescriptionField: UITextField!
    @IBOutlet weak var addNewTaskButton: UIButton!
    
    var list: ListModel = ListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewTaskButton.isEnabled = false
    }
    
    @IBAction func addNewTaskButtonPressed(_ sender: UIButton) {
        let newTask = TaskModel()
        newTask.title = taskTitleField.text!
        newTask.taskDescription = taskDescriptionField.text!
        FactoryStorage.addTask(list, task: newTask)
        dismiss(animated: true)
    }
    
    @IBAction func descriptioFieldChanged(_ sender: UITextField) {
        guard sender.text != "" && taskTitleField.text != "" else {
            addNewTaskButton.isEnabled = false
            return
        }
        addNewTaskButton.isEnabled = true
    }
}
