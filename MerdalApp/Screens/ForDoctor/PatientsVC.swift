//
//  HomeVC.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 9.05.2023.
//

import UIKit
import Firebase

class PatientsVC: UIViewController {
    
    var doctor: Doctor!
    let db = Firestore.firestore()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManagement()
    }
    
    private func configureView() {
        title = "Hastalarınız"
        view.backgroundColor = .systemBackground
        addSignOutButtonToNavigationBar()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person.fill.badge.plus"),
            style: .done,
            target: self,
            action: #selector(plusButtonPressed))
    }
    
    private func configureTableView() {
        doctor = AuthManager.shared.doctor!
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PatientCell.self, forCellReuseIdentifier: PatientCell.reuseID)
        
    }
    
    @objc private func plusButtonPressed() {
        let alert = UIAlertController(title: "Hasta Ekleme", message: "Eklemek istediğiniz hastanın mail hesabını girin 📬", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Ekle", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            guard let field = alert.textFields!.first, let text = field.text, !text.isEmpty else { return }
            self.addDoctorToDatabase(patientMail: text)
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alert, animated: true)
    }
    
    private func addDoctorToDatabase(patientMail: String) {
        db.collection("hasta").getDocuments { [weak self] q, e in
            guard let self else { return }
            let wantedDatas = q!.documents.filter { $0.data()["email"] as! String == patientMail }
            if wantedDatas.isEmpty {
                self.presentAlert(title: "Hata!!!", message: "Böyle bir email bulunamadı", buttonTitle: "Tamam")
            } else {
                db.collection("doktor").getDocuments { [weak self] q, e in
                    guard let self else { return }
                    let wantedDoctors = q!.documents.filter { ($0.data()["email"] as! String) == AuthManager.shared.doctor?.email }
                    
                    var hastaMailleri: [String] = []
                    for hasta in AuthManager.shared.doctor!.patiens ?? [Patient]() {
                        hastaMailleri.append(hasta.email)
                    }
                    
                    var end = false
                    for data in wantedDatas {
                        if hastaMailleri.contains(data.data()["email"] as! String) {
                            end = true
                        }
                    }
                    
                    if end == false {
                        hastaMailleri.append(patientMail)
                        let mailler = hastaMailleri
                        
                        self.db.collection("doktor").document(wantedDoctors.first!.documentID).setData([
                            "email": AuthManager.shared.doctor!.email,
                            "isim": AuthManager.shared.doctor!.email,
                            "hastalar": mailler
                        ])
                        
                        dataManagement()
                        tableView.reloadData()
                    } else {
                        presentAlert(title: "Upss!", message: "Bu kullanıcıyı zaten eklemişsiniz", buttonTitle: "Tamam")
                    }
                }
            }
        }
    }
    
    private func dataManagement() {
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        
        db.collection("doktor").getDocuments { [weak self] querySnapshot, error in
            guard let self, error == nil else { return }
            let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
            let doktorVerileri = wantedDatas.first!.data()
            
            let hastalarınİsimleri: [String] = doktorVerileri["hastalar"] as! [String]
            
            // hastaların verilerini buldum
            db.collection("hasta").getDocuments { querySnapshot, error in
                guard error == nil else { return }
                // doktorun hastalarını buldum
                let wantedDatas = querySnapshot!.documents.filter { hastalarınİsimleri.contains($0.data()["email"] as! String) } // hastalar
                
                if wantedDatas.isEmpty {
                    AuthManager.shared.doctor = Doctor(name: doktorVerileri["isim"] as! String, email: doktorVerileri["email"] as! String, patiens: nil)
                    self.configureView()
                    self.configureTableView()
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
                            
                            AuthManager.shared.doctor = Doctor(name: doktorVerileri["isim"] as! String, email: doktorVerileri["email"] as! String, patiens: patiens)
                            print(AuthManager.shared.doctor!)
                            self.configureView()
                            self.configureTableView()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

extension PatientsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AuthManager.shared.doctor!.patiens?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PatientCell.reuseID) as! PatientCell
        cell.set(text: AuthManager.shared.doctor!.patiens![indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PatientVC()
        vc.patient = AuthManager.shared.doctor!.patiens![indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        // model silindi
        AuthManager.shared.doctor!.patiens?.remove(at: indexPath.row)
        
        // veri tabanı silindi
        db.collection("doktor").getDocuments { [weak self] q, e in
            guard let self else { return }
            
            let wantedDoctors = q!.documents.filter { ($0.data()["email"] as! String) == AuthManager.shared.doctor?.email }
            
            var hastaMailleri: [String] = []
            for hasta in AuthManager.shared.doctor!.patiens ?? [Patient]() {
                hastaMailleri.append(hasta.email)
            }
            let mailler = hastaMailleri
            
            self.db.collection("doktor").document(wantedDoctors.first!.documentID).setData([
                "email": AuthManager.shared.doctor!.email,
                "isim": AuthManager.shared.doctor!.email,
                "hastalar": mailler
            ])
            
            tableView.reloadData()
        }
        
    }
    
}
