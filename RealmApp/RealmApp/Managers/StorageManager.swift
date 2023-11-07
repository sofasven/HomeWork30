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
    
    static func deleteTasksList(tasksList: TasksList) {
        
        do {
            try realm.write {
                let tasks = tasksList.tasks
                realm.delete(tasks)
                realm.delete(tasksList)
            }
        } catch  {
            print("Error: \(error)")
        }

    }
    
    static func editTasksList(tasksList: TasksList,
                              newListName: String) {
        
        do {
            try realm.write {
                tasksList.name = newListName
            }
        } catch  {
            print("Error: \(error)")
        }
        
    }
    
    static func makeAllDone(tasksList: TasksList) {
        
        do {
            try realm.write {
                tasksList.tasks.setValue(true, forKey: "isComplited")
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
    
    static func saveTask(tasksList: TasksList, task: Task) {
        
        do {
            try realm.write {
                tasksList.tasks.append(task)
            }
        } catch  {
            print("Error: \(error)")
        }
    }
    
    static func makeDoneTask(task: Task) {
        
        do {
            try realm.write {
                task.isComplited.toggle()
            }
        } catch  {
            print("Error: \(error)")
        }
    }
    
    static func deleteTask(task: Task) {
        
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch  {
            print("Error: \(error)")
        }
    }
    static func editTask(task: Task, newName: String, newNote: String) {
        
        do {
            try realm.write {
                task.name = newName
                task.note = newNote
            }
        } catch  {
            print("Error: \(error)")
        }
    }
    
    static func findRealmFile() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
}
