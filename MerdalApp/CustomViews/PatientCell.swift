//
//  PatientCell.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 10.05.2023.
//

import UIKit

class PatientCell: UITableViewCell {

    static let reuseID = "PatientCellID"
    let text = MerTitle2()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(text: String) {
        self.text.text = text
    }
    
    private func configure() {
        addSubviews(text)
        text.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        text.textColor = .systemGray
        
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5),
            text.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ])
    }
}
