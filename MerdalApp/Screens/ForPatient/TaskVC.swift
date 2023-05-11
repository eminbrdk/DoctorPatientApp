//
//  TaskVC.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 9.05.2023.
//

import UIKit
import Firebase

class TaskVC: UIViewController {
    
    var taskIndex: Int!
    let taskTask = MerTitle2()
    let doneButton = MerButton(color: .systemGreen, text: "Yapıldı")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSubViews()
    }
    
    private func configureView() {
        title = "Görev"
        view.backgroundColor = .systemBackground
    }
    
    private func configureSubViews() {
        view.addSubviews(taskTask, doneButton)
        view.arrangeSidesDefault(views: taskTask, doneButton)
        
        NSLayoutConstraint.activate([
            taskTask.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            taskTask.heightAnchor.constraint(equalToConstant: 250),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            doneButton.heightAnchor.constraint(equalToConstant: Constans.buttonHeight)
        ])
        
        taskTask.text = AuthManager.shared.patient!.tasks[taskIndex].task
        taskTask.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        
        doneButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        if AuthManager.shared.patient!.tasks[taskIndex].done == true {
            doneButton.configuration?.baseForegroundColor = .systemGreen
            doneButton.configuration?.baseBackgroundColor = .systemGreen
            doneButton.setTitle("Yapıldı", for: .normal)
        } else {
            doneButton.configuration?.baseForegroundColor = .systemRed
            doneButton.configuration?.baseBackgroundColor = .systemRed
            doneButton.setTitle("Yapılmadı", for: .normal)
        }
    }
    
    @objc private func buttonPressed() {
        if AuthManager.shared.patient!.tasks[taskIndex].done == true {
            doneButton.configuration?.baseForegroundColor = .systemRed
            doneButton.configuration?.baseBackgroundColor = .systemRed
            doneButton.setTitle("Yapılmadı", for: .normal)
            
            AuthManager.shared.patient!.tasks[taskIndex].done = false
            changeData(b: false)
        } else {
            presentAlert(title: "Tebrikler 🥳", message: "Bir görevi daha başarıyla yerine getirdin", buttonTitle: "Tamam")
            doneButton.configuration?.baseForegroundColor = .systemGreen
            doneButton.configuration?.baseBackgroundColor = .systemGreen
            doneButton.setTitle("Yapıldı", for: .normal)
            
            AuthManager.shared.patient!.tasks[taskIndex].done = true
            changeData(b: true)
        }
    }
    
    private func changeData(b: Bool) {
        let patient = AuthManager.shared.patient
        let task = AuthManager.shared.patient!.tasks[taskIndex]
        let db = Firestore.firestore()
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        
        // puan değiştir
        var addPoint = 0
        if b == true {
            addPoint = 5
        } else {
            addPoint = -5
        }
        AuthManager.shared.patient?.point += addPoint
        
        // görev durumunu değiştir
        AuthManager.shared.patient!.tasks[self.taskIndex].done = b
        let a = AuthManager.shared.patient!.tasks
        
        db.collection("hasta").getDocuments { querySnapshot, error in
            guard error == nil else { return }
            
            let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
            let hastaID = wantedDatas.first!.documentID
            
            db.collection("hasta/\(hastaID)/görevler").getDocuments { querySnapshot, error in
                guard error == nil else { return }
                let wantedDatas = querySnapshot!.documents.filter { $0.data()["görev"] as! String == AuthManager.shared.patient!.tasks[self.taskIndex].task }
                
                let id = wantedDatas.first?.documentID
                
                db.collection("hasta").document(hastaID).setData([
                    "email": patient!.email,
                    "isim": patient!.name,
                    "puan": patient!.point + addPoint
                ])
                
                db.collection("hasta/\(hastaID)/görevler").document(id!).setData([
                    "görev": task.task,
                    "durum": b
                ])
            }
        }
    }

}
