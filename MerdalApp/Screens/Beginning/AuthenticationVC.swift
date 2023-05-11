//
//  AuthenticationVC2.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import UIKit
import Firebase

enum AuthenticationType {
    case signIn, register
}

class AuthenticationVC: UIViewController {

    var authType: AuthenticationType!
    
    let nameTextField = MerTextField(placeholder: "ad soayad")
    let emailTextField = MerTextField(placeholder: "email")
    let passwordTextField = MerTextField(placeholder: "şifre")
    let givenPasswordTextField = MerTextField(placeholder: "size verilen şifre")
    let button = MerButton(color: .systemGreen, text: "Kaydol")
    
    var textFields: [UITextField] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDismissKeyboardTapGesture()
        configureView()
        configureSubviews()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        
        if authType == .register {
            title = "Kaydol"
            textFields = [nameTextField, emailTextField, passwordTextField, givenPasswordTextField]
        } else {
            title = "Giriş Yap"
            button.setTitle("Giriş Yap", for: .normal)
            textFields = [emailTextField, passwordTextField]
        }
    }
    
    private func configureSubviews() {
        view.addSubview(button)
        view.arrangeSidesDefault(views: button)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: Constans.buttonHeight),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
        
        var padding: CGFloat = 25
        for item in textFields {
            view.addSubview(item)
            view.arrangeSidesDefault(views: item)
            item.delegate = self
            
            NSLayoutConstraint.activate([
                item.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
                item.heightAnchor.constraint(equalToConstant: 50)
            ])
            padding += 65
        }
    }
    
    @objc private func buttonPressed() {
        for item in textFields {
            if item.text?.isEmpty == true {
                presentAlert(title: "Upss Hata!!", message: "Lütfen tüm boşlukları doldurunuz", buttonTitle: "Ok")
                return
            }
        }
        
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        if authType == .register {
            if givenPasswordTextField.text == "1" {
                AuthManager.shared.userType = .doctor
            } else if givenPasswordTextField.text == "2" { // bu şifreleri constanta alll
                AuthManager.shared.userType = .patient
            } else {
                presentAlert(title: "Upss Hata!!", message: "Size verilen şifreyi yanlış girdiniz", buttonTitle: "Ok")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self else { return }
                guard error == nil else {
                    presentAlert(title: "Upss Hata!!", message: error!.localizedDescription, buttonTitle: "Ok")
                    return
                }
                self.createUser()
                self.registerSucccessfuly()
            }
        } else {
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                guard let self else { return }
                guard error == nil else {
                    presentAlert(title: "Upss Hata!!", message: error!.localizedDescription, buttonTitle: "Ok")
                    return
                }
                self.signInSuccessfuly()
            }
        }
    }
    
    private func registerSucccessfuly() {
        AuthManager.shared.assignUser()
        
        if AuthManager.shared.userType == .patient {
            let nc1 = UINavigationController(rootViewController: TasksVC())
            nc1.navigationBar.prefersLargeTitles = true
            nc1.tabBarItem = UITabBarItem(title: "Görevler", image: UIImage(systemName: "list.bullet.clipboard"), tag: 0)
            
            let nc2 = UINavigationController(rootViewController: ProfileVC())
            nc2.navigationBar.prefersLargeTitles = true
            nc2.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.crop.circle"), tag: 1)
            
            let tbc = UITabBarController()
            tbc.viewControllers = [nc1, nc2]
            tbc.modalPresentationStyle = .fullScreen
            present(tbc, animated: false)
        } else {
            let nc = UINavigationController(rootViewController: PatientsVC())
            nc.navigationBar.prefersLargeTitles = true
            nc.navigationItem.largeTitleDisplayMode = .always
            nc.modalPresentationStyle = .fullScreen
            present(nc, animated: false)
        }
    }
    
    private func signInSuccessfuly() {
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        
        db.collection("doktor").getDocuments { [weak self] querySnapshot, error in
            guard let self, error == nil else { return }
            let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
            
            if wantedDatas.isEmpty == false {
                AuthManager.shared.userType = .doctor
                AuthManager.shared.assignUser()
                
                let nc = UINavigationController(rootViewController: PatientsVC())
                nc.navigationBar.prefersLargeTitles = true
                nc.navigationItem.largeTitleDisplayMode = .always
                nc.modalPresentationStyle = .fullScreen
                present(nc, animated: false)
            } else {
                AuthManager.shared.userType = .patient
                AuthManager.shared.assignUser()
                //AuthManager.shared.assignTasks()
                
                let nc1 = UINavigationController(rootViewController: TasksVC())
                nc1.navigationBar.prefersLargeTitles = true
                nc1.tabBarItem = UITabBarItem(title: "Görevler", image: UIImage(systemName: "list.bullet.clipboard"), tag: 0)
                
                let nc2 = UINavigationController(rootViewController: ProfileVC())
                nc2.navigationBar.prefersLargeTitles = true
                nc2.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.crop.circle"), tag: 1)
                
                let tbc = UITabBarController()
                tbc.viewControllers = [nc1, nc2]
                tbc.modalPresentationStyle = .fullScreen
                self.present(tbc, animated: false)
            }
        }
    }
    
    private func createUser() {
        var num = ""
        for _ in 0...20 {
            let a = Int.random(in: 0...100)
            num += "\(a)"
        }
        
        if AuthManager.shared.userType == .doctor {
            AuthManager.shared.doctor = Doctor(name: nameTextField.text!, email: emailTextField.text!, patiens: nil)
            let doc = AuthManager.shared.doctor!
            
            db.collection("doktor").addDocument(data: [
                "isim": doc.name,
                "email": doc.email,
                "hastalar": [String]()
            ])
        } else {
            let tasks: [Task] = [
                Task(task: "Günde 2 litre su iç"),
                Task(task: "1.5 saat bounca hiç konuşma"),
                Task(task: "Doğa yürüyüşüne çık"),
                Task(task: "Götünü 5 kez parmakla"),
                Task(task: "Amuda kalkıp ilerle"),
                Task(task: "falan filan")
            ]
            
            AuthManager.shared.patient = Patient(name: nameTextField.text!, point: 0, email: emailTextField.text!, tasks: tasks)
            //AuthManager.shared.assignTasks()
            let patient = AuthManager.shared.patient!
            
            //internete görevi atadık
            db.collection("hasta").addDocument(data: [
                "isim": patient.name,
                "puan": patient.point,
                "email": patient.email
            ])
            print("a")
            
            db.collection("hasta").getDocuments { [self] querySnapshot, error in
                guard error == nil else { return }
                let wantedDocuments = querySnapshot!.documents.filter { $0.data()["email"] as! String == emailTextField.text! }
                let documentID = wantedDocuments.first!.documentID
                print("b")
                for task in tasks {
                    db.collection("/hasta/\(documentID)/görevler").addDocument(data: [
                        "durum": task.done,
                        "görev": task.task
                    ])
                    print("c")
                }
            }
        }
    }
}

extension AuthenticationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        buttonPressed()
        return true
    }
}
