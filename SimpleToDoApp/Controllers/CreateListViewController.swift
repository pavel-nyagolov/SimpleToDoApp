//
//  CreateListViewController.swift
//  SimpleToDoApp
//
//  Created by Pavel on 10.03.23.
//

import UIKit

class CreateListViewController: UIViewController {

    @IBOutlet weak var listTitleField: UITextField!
    @IBOutlet weak var addNewListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewListButton.isEnabled = false
    }
    
    @IBAction func addNewListButtonPressed(_ sender: UIButton) {
        let newList = ListModel()
        newList.title = listTitleField.text!
        FactoryStorage.addList(newList)
        dismiss(animated: true)
    }
    
    @IBAction func listNameChanged(_ sender: UITextField) {
        guard sender.text != "" else {
            addNewListButton.isEnabled = false
            return
        }
        addNewListButton.isEnabled = true
    }
}
