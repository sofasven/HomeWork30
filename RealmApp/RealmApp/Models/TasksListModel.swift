//
//  TasksListModel.swift
//  RealmApp
//
//  Created by Sofa on 1.11.23.
//

import Foundation
import RealmSwift


class TasksList: Object {
    
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
    
}
