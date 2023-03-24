//
//  ListViewController.swift
//  SimpleToDoApp
//
//  Created by Pavel on 10.03.23.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tasksTableView: UITableView!
    
    var isEditingClicked = false
    var list: ListModel = ListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = list.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: .updateTaskNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.updateData()
        }
        
        guard let listStorage = FactoryStorage.getList(id: list.id) else {
            return
        }
        list = listStorage
        tasksTableView.reloadData()
    }
    
    func updateData() {
        DispatchQueue.main.async {
            guard let listStorage = FactoryStorage.getList(id: self.list.id) else {
                return
            }
            self.list = listStorage
            self.tasksTableView.reloadData()
        }
    }
    
    @IBAction func addTaskButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.createNewTask, sender: self)
    }
    
    @IBAction func didEditClicked(_ sender: UIBarButtonItem) {
        if !isEditingClicked {
            tasksTableView.setEditing(true, animated: true)
            sender.title = "Done"
            isEditingClicked = true
        } else {
            tasksTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            isEditingClicked = false
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if list.tasks.isEmpty {
            let label = UILabel()
            label.text = "No Tasks"
            label.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return list.tasks.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.taskCellIdentifier) else {
            return UITableViewCell()
        }

        cell.textLabel?.text = list.tasks[indexPath.row].title
        cell.detailTextLabel?.text = list.tasks[indexPath.row].taskDescription

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.taskDetails, sender: list.tasks[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        FactoryStorage.deleteTask(list.tasks[indexPath.row])
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueDestination = segue.destination as? CreateTaskViewController {
            segueDestination.list = list
        }
        else if let segueDestination = segue.destination as? TaskViewController {
            segueDestination.task = sender as! TaskModel
        }
        
    }
}
