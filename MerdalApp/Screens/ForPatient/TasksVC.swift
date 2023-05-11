//
//  TasksVC.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 9.05.2023.
//

import UIKit
import Firebase

class TasksVC: UIViewController {

    var tasks: [Task] = []
    let tableView = UITableView()
    var ilkGiriş = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignTasks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ilkGiriş != 0 {
            self.tasks = AuthManager.shared.patient!.tasks
            tableView.reloadData()
        }
        ilkGiriş += 1
    }
    
    private func assignTasks() {
        let db = Firestore.firestore()
        guard let email = FirebaseAuth.Auth.auth().currentUser?.email else { return }
        
        db.collection("hasta").getDocuments { [weak self] querySnapshot, error in
            guard let self, error == nil else { return }
            
            let wantedDatas = querySnapshot!.documents.filter { $0.data()["email"] as! String == email }
            AuthManager.shared.userType = .patient
            
            
            let d = wantedDatas.first!.data()
            let id = wantedDatas.first!.documentID
            
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
                
                //AuthManager.shared.assignTasks()
                self.tasks = AuthManager.shared.patient!.tasks
                print(AuthManager.shared.patient!)
                self.configureView()
                self.configureTableView()
            }
            
            
            
            
            //AuthManager.shared.assignPatient(d: wantedDatas.first!.data(), id: wantedDatas.first!.documentID)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = "Görevler"
        addSignOutButtonToNavigationBar()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TasksCell.self, forCellReuseIdentifier: TasksCell.reuseID)
    }
}

extension TasksVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksCell.reuseID) as! TasksCell
        cell.set(text: tasks[indexPath.row].task, checkes: tasks[indexPath.row].done)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TaskVC()
        vc.taskIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
}
