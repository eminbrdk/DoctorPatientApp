//
//  PatientVC.swift
//  MerdalApp
//
//  Created by Muhammed Emin Bardakcı on 11.05.2023.
//

import UIKit

class PatientVC: UIViewController {

    var patient: Patient!
    
    let scrollView = UIScrollView()
    
    let pointContainerView = UIView()
    let pointStackView = UIStackView()
    let pointTitle = MerTitle1(text: "Puan: ")
    let point = MerTitle2()
    
    let tasksDoneTitle = MerTitle1(text: "Yapılan Görevler")
    var taskTexts = [MerTitle2]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureSubViews()
    }
    
    private func configureView() {
        title = patient.name
        view.backgroundColor = .systemBackground
        point.text = "\(patient.point)"
    }
    
    private func configureSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubviews(pointContainerView, tasksDoneTitle)
        pointContainerView.addSubview(pointStackView)
        pointStackView.addArrangedSubview(pointTitle)
        pointStackView.addArrangedSubview(point)
        
        pointStackView.distribution = .fill
        pointStackView.alignment = .leading
        pointStackView.alignment = .bottom
        pointStackView.axis = .horizontal
        pointStackView.spacing = 2
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pointContainerView.translatesAutoresizingMaskIntoConstraints = false
        pointStackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.arrangeSidesDefault(views: pointContainerView, tasksDoneTitle)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            pointContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            pointContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            tasksDoneTitle.topAnchor.constraint(equalTo: pointContainerView.bottomAnchor),
            tasksDoneTitle.heightAnchor.constraint(equalToConstant: 55),
        ])
        
        configureTasks()
    }
    
    private func configureTasks() {
        var num = 0
        
        for task in patient.tasks {
            if task.done == true {
                let text = MerTitle2(text: task.task)
                text.textColor = .systemGreen
                taskTexts.append(text)
                scrollView.addSubview(text)
                scrollView.arrangeSidesDefault(views: text)
                
                NSLayoutConstraint.activate([text.heightAnchor.constraint(equalToConstant: 40)])
                if num == 0 {
                    NSLayoutConstraint.activate([text.topAnchor.constraint(equalTo: tasksDoneTitle.bottomAnchor, constant: 5)])
                } else {
                    NSLayoutConstraint.activate([text.topAnchor.constraint(equalTo: taskTexts[num - 1].bottomAnchor, constant: 10)])
                }
                print(num)
                num += 1
            }
        }
    }
}
