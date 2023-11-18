//
//  TasksTVC.swift
//  RealmApp
//
//  Created by Sofa on 1.11.23.
//

import UIKit
import RealmSwift

enum TasksTVCFlow {
    case addingNewTask
    case editingTask(task: Task)
}

struct TxtAlertData {
    
    let titleForAlert = "Task value"
    let messageForAlert: String
    let doneButtonForAlert: String
    let cancelTxt = "Cancel"
    
    let newTFPlaceholder = "New task"
    let noteTFPlaceholder = "Note"
    
    var taskName: String?
    var taskNote: String?
    
    init(tasksTVCFlow: TasksTVCFlow) {
        switch tasksTVCFlow {
        case .addingNewTask:
            messageForAlert = "Please insert new task value"
            doneButtonForAlert = "Save"
        case .editingTask(let task):
            messageForAlert = "Please edit your task"
            doneButtonForAlert = "Update"
            taskName = task.name
            taskNote = task.note
        }
    }
}

class TasksTVC: UITableViewController {
    
    var currentTasksList: TasksList?
    private var notCompletedTasks: Results<Task>!
    private var completedTasks: Results<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentTasksList?.name
        filteringTasks()
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        let editBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action:#selector(editBarButtonSystemItemSelector))
        navigationItem.setRightBarButtonItems([editBtn, add], animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { 2 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? notCompletedTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Not completed tasks" : "Completed tasks"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = indexPath.section == 0 ? notCompletedTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteContextualAction =  UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deleteTask(task: task)
            self?.filteringTasks()
        }
        
        let editContextualAction =  UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesTask(tasksTVCFlow: .editingTask(task: task))
        }
        
        let doneText = task.isComplited ? "Not done" : "Done"
        let doneContextualAction =  UIContextualAction(style: .destructive, title: doneText) { [weak self] _, _, _ in
            StorageManager.makeDoneTask(task: task)
            self?.filteringTasks()
        }
        
        deleteContextualAction.backgroundColor = .red
        editContextualAction.backgroundColor = .gray
        doneContextualAction.backgroundColor = .green
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteContextualAction, editContextualAction, doneContextualAction])
        return swipeActionsConfiguration
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool { true }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }
    
    @objc
    private func editBarButtonSystemItemSelector() {
        self.isEditing = true
    }


    private func filteringTasks() {
        notCompletedTasks = currentTasksList?.tasks.filter("isComplited = false")
        completedTasks = currentTasksList?.tasks.filter("isComplited = true")
        tableView.reloadData()
    }
    @objc
    private func addBarButtonSystemItemSelector() {
        alertForAddAndUpdatesTask(tasksTVCFlow: .addingNewTask)
    }
    
    private func alertForAddAndUpdatesTask(tasksTVCFlow: TasksTVCFlow) {
        
        let txtAlertData = TxtAlertData(tasksTVCFlow: tasksTVCFlow)
        
        let alert = UIAlertController(title: txtAlertData.titleForAlert,
                                                message: txtAlertData.messageForAlert,
                                                preferredStyle: .alert)
        
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = txtAlertData.newTFPlaceholder
            taskTextField.text = txtAlertData.taskName
        }
        
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = txtAlertData.noteTFPlaceholder
            noteTextField.text = txtAlertData.taskNote
        }
        
        let saveAction = UIAlertAction(title: txtAlertData.doneButtonForAlert, style: .default) { [weak self] _ in
            guard let self,
                  let newTaskName = taskTextField.text, !newTaskName.isEmpty,
                  let noteTask = noteTextField.text, !noteTask.isEmpty,
                  let currentTasksList = self.currentTasksList else { return }
            switch tasksTVCFlow {
                case .addingNewTask:
                    let task = Task()
                    task.name = newTaskName
                    task.note = noteTask
                StorageManager.saveTask(tasksList: currentTasksList, task: task)
                
                case .editingTask(let task):
                StorageManager.editTask(task: task, newName: newTaskName, newNote: noteTask)
            }
            self.filteringTasks()
        }
        
        let cancelAction = UIAlertAction(title: txtAlertData.cancelTxt, style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
