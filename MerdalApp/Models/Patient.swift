//
//  Patient.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 9.05.2023.
//

import Foundation

struct Patient {
    let name: String
    var point: Int
    let email: String
    var tasks: [Task]
    
    init(name: String, point: Int, email: String, tasks: [Task]) {
        self.name = name
        self.point = point
        self.email = email
        self.tasks = tasks
    }
}
