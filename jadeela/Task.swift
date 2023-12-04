//
//  Task.swift
//  jadeela
//
//  Created by aisha rashid alshammari  on 19/05/1445 AH.
//

import Foundation
import SwiftData
@Model
class TaskModel {
    var name: String = ""
    var date: Date = Date()
    var note: String = ""

    init(name: String, date: Date , note: String) {
        self.name = name
        self.date = date
        self.note = note

    }

}
