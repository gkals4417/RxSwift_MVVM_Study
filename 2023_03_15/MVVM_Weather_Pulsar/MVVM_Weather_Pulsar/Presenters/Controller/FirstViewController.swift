//
//  FirstViewController.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit

class FirstViewController: UIViewController {
    
    let myView = HomeView()
    let viewModel = WeatherViewModel(city: "Seoul")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        viewModel.configure(myView)
        
        
        self.view.addSubview(myView)
        
        myView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            myView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            myView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            myView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            myView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        ])
    }
    
    

}
