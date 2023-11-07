//
//  TasksListTVC.swift
//  RealmApp
//
//  Created by Sofa on 1.11.23.
//

import UIKit
import RealmSwift

class TasksListTVC: UITableViewController {
    
    var tasksLists: Results<TasksList>!

    override func viewDidLoad() {
        super.viewDidLoad()
       // StorageManager.deleteAll()
        tasksLists = StorageManager.getAllTasksLists().sorted(byKeyPath: "name")
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        navigationItem.setRightBarButton(add, animated: true)
    }

    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        let byKeyPath = sender.selectedSegmentIndex == 0 ? "name" : "date"
        tasksLists = tasksLists.sorted(byKeyPath: byKeyPath)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let taskList = tasksLists[indexPath.row]
        cell.configure(with: taskList)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deleteContextualAction =  UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deleteTasksList(tasksList: currentList)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContextualAction =  UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesListTasks(currentList: currentList, indexPath: indexPath)
        }
        let doneContextualAction =  UIContextualAction(style: .destructive, title: "Done") { [weak self] _, _, _ in
            StorageManager.makeAllDone(tasksList: currentList)
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        deleteContextualAction.backgroundColor = .red
        editContextualAction.backgroundColor = .gray
        doneContextualAction.backgroundColor = .green
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction, doneContextualAction])
        return swipeActionsConfiguration
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let destVC = segue.destination as? TasksTVC,
          let indexPath = tableView.indexPathForSelectedRow {
           let currentTasksList = tasksLists[indexPath.row]
           destVC.currentTasksList = currentTasksList
       }
        
    }

    @objc
    private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesListTasks()
    }
    
    private func alertForAddAndUpdatesListTasks(currentList: TasksList? = nil, indexPath: IndexPath? = nil) {
        let title = currentList == nil ? "New list" : "Edit list"
        let message = "Please insert list name"
        let doneBtnName = currentList == nil ? "Save" : "Update"
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        let saveAction = UIAlertAction(title: doneBtnName, style: .default) { [weak self] _ in
            guard let self,
                  let newListName = alertTextField.text,
                  !newListName.isEmpty else { return }
            
            if let currentList = currentList,
               let indexPath = indexPath {
                StorageManager.editTasksList(tasksList: currentList, newListName: newListName)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                let taskList = TasksList()
                taskList.name = newListName
                StorageManager.saveTasksList(tasksList: taskList)
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.text = currentList?.name
            alertTextField.placeholder = "List name"
        }
        present(alertController, animated: true)
    }
}
