//
//  TasksCell.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 9.05.2023.
//

import UIKit

class TasksCell: UITableViewCell {

    static let reuseID = "TasksCellID"
    let text = MerTitle2()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String, checkes: Bool = false) {
        self.text.text = text
        if checkes == false {
            self.text.textColor = .systemGray
        } else {
            self.text.textColor = .systemGreen
        }
    }
    
    private func configure() {
        addSubviews(text)
        text.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            text.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ])
    }
}
