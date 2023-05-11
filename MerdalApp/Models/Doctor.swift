//
//  Doctor.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 9.05.2023.
//

import Foundation

struct Doctor {
    let name: String
    let email: String
    var patiens: [Patient]?
    
    init(name: String, email: String, patiens: [Patient]?) {
        self.name = name
        self.email = email
        self.patiens = patiens
    }
}
