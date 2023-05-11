//
//  MerTitle1.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit

class MerTitle1: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    private func configure() {
        textColor = .label
        numberOfLines = 0
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
}
