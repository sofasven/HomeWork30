//
//  ListModel.swift
//  RealmApp
//
//  Created by Sofa on 1.11.23.
//

import Foundation
import RealmSwift

class Task: Object {
    
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplited = false
    
}
