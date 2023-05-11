//
//  Ext+UIViewController.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit
import Firebase

extension UIViewController {
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        let vc = MerAlert(title: title, message: message, buttonTitle: buttonTitle)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    func addSignOutButtonToNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Çıkış Yap", style: .done, target: self, action: #selector(signOutButtonPressed))
    }
    
    @objc func signOutButtonPressed() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            return
        }
        
        let vc = WelcomeVC()
        let nc = UINavigationController(rootViewController: vc)
        nc.navigationBar.prefersLargeTitles = true
        nc.navigationItem.largeTitleDisplayMode = .always
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: false)
    }
}
