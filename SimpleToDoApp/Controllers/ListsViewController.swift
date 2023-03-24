//
//  ViewController.swift
//  SimpleToDoApp
//
//  Created by Pavel on 10.03.23.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet weak var listsTableView: UITableView!
    
    var isEditingClicked = false
    var lists: [ListModel] = [] {
        didSet {
            listsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .updateListNotification, object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.updateData()
        }
        
        guard let listStorage = FactoryStorage.getLists() else {
            return
        }
        lists = listStorage
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    func updateData() {
        DispatchQueue.main.async {
            guard let listsStorage = FactoryStorage.getLists() else{
                return
            }
            self.lists = listsStorage
        }
    }
    
    @IBAction func didEditClicked(_ sender: UIBarButtonItem) {
        if !isEditingClicked {
            listsTableView.setEditing(true, animated: true)
            sender.title = "Done"
            isEditingClicked = true
        } else {
            listsTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            isEditingClicked = false
        }
    }
    
}

extension ListsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lists.isEmpty {
            let label = UILabel()
            label.text = "No Lists"
            label.textAlignment = .center
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.listCellIdentifier) else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text =  lists[indexPath.row].title
        let taskCount = lists[indexPath.row].tasks.count
        if taskCount > 1 || taskCount == 0 {
            cell.detailTextLabel?.text = "\(taskCount) Tasks"
        } else {
            cell.detailTextLabel?.text = "\(taskCount) Task"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedList = lists[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.homeToList, sender: selectedList)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        FactoryStorage.deleteList(lists[indexPath.row])
        updateData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueDestination = segue.destination as? ListViewController else {
            return
        }
        
        segueDestination.list = sender.self as! ListModel
    }
    
    
}
