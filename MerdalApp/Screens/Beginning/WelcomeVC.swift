//
//  ViewController.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit

enum userType {
    case patient, doctor
}

class WelcomeVC: UIViewController {
    
    let introduction = MerTitle1(text: "Uygulama hakkında tanıtım cart curt diye gidiyor burası ...")
    let registerButton = MerButton(color: .systemBlue, text: "Kaydol")
    let signInButton = MerButton(color: .systemBlue, text: "Giriş yap")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSubviews()
    }

    private func configureView() {
        title = "MerdalApp"
        view.backgroundColor = .systemBackground
        view.addSubviews(introduction, registerButton, signInButton)
    }
    
    private func configureSubviews() {
        view.arrangeSidesDefault(views: introduction, registerButton, signInButton)
        
        NSLayoutConstraint.activate([
            registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            registerButton.heightAnchor.constraint(equalToConstant: Constans.buttonHeight),
            
            signInButton.bottomAnchor.constraint(equalTo: registerButton.topAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: Constans.buttonHeight),
            
            introduction.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            introduction.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        introduction.textAlignment = .center
        introduction.font = UIFont.systemFont(ofSize: 28)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    @objc private func registerButtonTapped() {
        let vc = AuthenticationVC()
        vc.authType = .register
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func signInButtonTapped() {
        let vc = AuthenticationVC()
        vc.authType = .signIn
        navigationController?.pushViewController(vc, animated: true)
    }

}

