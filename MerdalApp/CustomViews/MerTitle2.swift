//
//  MerTitle2.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit

class MerTitle2: UILabel {

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
        textColor = .secondaryLabel
        numberOfLines = 0
        textAlignment = .left
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }

}
