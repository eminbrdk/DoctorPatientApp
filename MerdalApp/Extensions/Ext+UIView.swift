//
//  Ext+UIView.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for item in views {
            addSubview(item)
        }
    }
    
    func arrangeSidesDefault(views: UIView...) {
        let padding: CGFloat = 20
        for item in views {
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            ])
        }
    }
}
