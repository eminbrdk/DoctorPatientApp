//
//  AuthManager.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 8.05.2023.
//

import Foundation
import Firebase

enum UserType {
    case patient, doctor
}

class AuthManager {
    static let shared = AuthManager()
    
    var userType: UserType!
    
    var doctor: Doctor?
    
    var patient: Patient?
    
    private let db = Firestore.firestore()
    
    
    func assignUser() {
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        
        if userType == .doctor { // burasıda kayıt olunurken için açıldı
            db.collection("doktor").getDocuments { [weak self] querySnapshot, error in
                guard let self, error == nil else { return }
                
                let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
                self.assignDoctor(doktorVerileri: wantedDatas.first!.data())
            }
        } else if userType == .patient {
            db.collection("hasta").getDocuments { [weak self] querySnapshot, error in
                guard let self, error == nil else { return }
                print(email)
                let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
                
                self.assignPatient(d: wantedDatas.first!.data(), id: wantedDatas.first!.documentID)
            }
        }
    }
    
    func assignUserForDirectEnter() {
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        
        // şu db işlemi en son gerçekleşiyor buna bir çözüm bul
        db.collection("doktor").getDocuments { [weak self] querySnapshot, error in
            guard let self, error == nil else { return }
            let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
            
            if wantedDatas.isEmpty == false {
                userType = .doctor
                self.assignDoctor(doktorVerileri: wantedDatas.first!.data())
                
                let nc = UINavigationController(rootViewController: PatientsVC())
                nc.navigationBar.prefersLargeTitles = true
                nc.navigationItem.largeTitleDisplayMode = .always
                SceneDelegate().window?.rootViewController = nc
            } else {
                userType = .patient
                db.collection("hasta").getDocuments { [weak self] querySnapshot, error in
                    guard let self, error == nil else { return }
                    
                    let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
                    self.assignPatient(d: wantedDatas.first!.data(), id: wantedDatas.first!.documentID)
                }
                
                let nc1 = UINavigationController(rootViewController: TasksVC())
                nc1.navigationBar.prefersLargeTitles = true
                nc1.tabBarItem = UITabBarItem(title: "Görevler", image: UIImage(systemName: "list.bullet.clipboard"), tag: 0)
                
                let nc2 = UINavigationController(rootViewController: ProfileVC())
                nc2.navigationBar.prefersLargeTitles = true
                nc2.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person.crop.circle"), tag: 1)
                
                let tbc = UITabBarController()
                tbc.viewControllers = [nc1, nc2]
                SceneDelegate().window?.rootViewController = tbc
            }
        }
    }
    
    func assignDoctor(doktorVerileri: [String : Any]) {
        let hastalarınİsimleri: [String] = doktorVerileri["hastalar"] as! [String]
        
        // hastaların verilerini buldum
        db.collection("hasta").getDocuments { querySnapshot, error in
            guard error == nil else { return }
            // doktorun hastalarını buldum
            let wantedDatas = querySnapshot!.documents.filter { hastalarınİsimleri.contains($0.data()["email"] as! String) } // hastalar
            
            if wantedDatas.isEmpty {
                AuthManager.shared.doctor = Doctor(name: doktorVerileri["isim"] as! String, email: doktorVerileri["email"] as! String, patiens: nil)
            } else {
                
                // her bir hastayı bulup doktora işlicem
                var patiens: [Patient] = []
                for data in wantedDatas {
                    let hastalarınVerileri = data.data()
                    let id = data.documentID
                    
                    // hastaların görevlerini işledim
                    self.db.collection("/hasta/\(id)/görevler").getDocuments { querySnapshot, error in
                        guard error == nil else { return }
                        
                        // hastanın görevleri
                        let wantedDatas = querySnapshot!.documents
                        var tasks: [Task] = []
                        
                        for data in wantedDatas {
                            let görev = data.data()["görev"] as! String
                            let durum = data.data()["durum"] as! Bool
                            let task = Task(task: görev, done: durum)
                            tasks.append(task)
                        }
                        patiens.append(Patient(name: hastalarınVerileri["isim"] as! String, point: hastalarınVerileri["puan"] as! Int, email: hastalarınVerileri["email"] as! String, tasks: tasks ))
                    }
                }
                AuthManager.shared.doctor = Doctor(name: doktorVerileri["isim"] as! String, email: doktorVerileri["email"] as! String, patiens: patiens)
            }
        }
    }
    
    func assignPatient(d: [String : Any], id: String) {
        db.collection("/hasta/\(id)/görevler").getDocuments { querySnapshot, error in
            guard error == nil else { return }
            
            let wantedDatas = querySnapshot!.documents
            var tasks: [Task] = []
            
            for data in wantedDatas {
                let görev = data.data()["görev"] as! String
                let durum = data.data()["durum"] as! Bool
                let task = Task(task: görev, done: durum)
                tasks.append(task)
            }
            AuthManager.shared.patient = Patient(name: d["isim"] as! String, point: d["puan"] as! Int, email: d["email"] as! String, tasks: tasks)
        }
    }
}
