//
//  StorageManager.swift
//  RealmApp
//
//  Created by Sofa on 1.11.23.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func getAllTasksLists() -> Results<TasksList> {
        realm.objects(TasksList.self)
    }
    
    static func deleteAll() {
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch  {
            print("Error: \(error)")
        }

    }
    
    static func saveTasksList(tasksList: TasksList) {
        
        do {
            try realm.write {
                realm.add(tasksList)
            }
        } catch  {
            print("Error: \(error)")
        }
        
    }
    
}
