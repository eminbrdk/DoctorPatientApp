//
//  ProfileVC.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 9.05.2023.
//

import UIKit

class ProfileVC: UIViewController {

    let name = MerTitle1()
    let pointView = UIStackView()
    let pointConView = UIView()
    let pointTitle = MerTitle1(text: "Puan: ")
    let point = MerTitle2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let patient = AuthManager.shared.patient!
        point.text = "\(patient.point)"
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        title = AuthManager.shared.patient!.name
        addSignOutButtonToNavigationBar()
    }
    
    private func configureSubviews() {
        let patient = AuthManager.shared.patient!
        
        view.addSubviews(pointConView)
        pointConView.addSubview(pointView)
        view.arrangeSidesDefault(views: pointConView)
        
        pointConView.translatesAutoresizingMaskIntoConstraints = false
        pointView.translatesAutoresizingMaskIntoConstraints = false
        pointView.addArrangedSubview(pointTitle)
        pointView.addArrangedSubview(point)
        pointView.distribution = .fill
        pointView.alignment = .leading
        pointView.alignment = .bottom
        
        name.text = patient.name
        name.font = UIFont.systemFont(ofSize: 23, weight: .heavy)
        pointTitle.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        point.text = "\(patient.point)"
        point.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        
        NSLayoutConstraint.activate([
            pointConView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pointConView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

}
