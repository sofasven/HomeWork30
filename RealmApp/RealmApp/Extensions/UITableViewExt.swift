//
//  UITableViewExt.swift
//  RealmApp
//
//  Created by Sofa on 7.11.23.
//

import UIKit

extension UITableViewCell {
    func configure(with tasksList: TasksList) {
        
        let notCompletedTasks = tasksList.tasks.filter("isComplited = false")
        let completedTasks = tasksList.tasks.filter("isComplited = true")

        textLabel?.text = tasksList.name

        if !notCompletedTasks.isEmpty {
            detailTextLabel?.text = "\(notCompletedTasks.count)"
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            detailTextLabel?.textColor = .red
        } else if !completedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
            detailTextLabel?.textColor = .green
        } else {
            detailTextLabel?.text = "0"
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            detailTextLabel?.textColor = .black
        }
    }
    
    
    
}
