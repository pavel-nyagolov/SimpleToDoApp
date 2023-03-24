//
//  TaskViewController.swift
//  SimpleToDoApp
//
//  Created by Pavel on 24.03.23.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    var task: TaskModel = TaskModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = task.title
        taskDescriptionLabel.text = task.taskDescription
    }
    
}
