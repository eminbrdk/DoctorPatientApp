//
//  MerTextField.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit

class MerTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderColor = CGColor(gray: 0.5, alpha: 0.7)
        layer.borderWidth = 1
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        textColor = .label
        clearButtonMode = .whileEditing
        
        autocorrectionType = .no
        returnKeyType = .done
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 1))
        leftViewMode = .always
        autocapitalizationType = .none
        
        //keyboardType = .emailAddress
        //textContentType = .password
    }
    
}
