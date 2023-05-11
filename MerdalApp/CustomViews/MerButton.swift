//
//  MerButton.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit

class MerButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, text: String) {
        self.init(frame: .zero)
        setTitle(text, for: .normal)
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        configuration = .borderedTinted()
        configuration?.cornerStyle = .medium
    }
}
