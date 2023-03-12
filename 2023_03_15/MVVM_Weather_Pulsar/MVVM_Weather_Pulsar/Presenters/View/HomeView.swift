//
//  HomeView.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/10.
//

import UIKit
import RxSwift
import RxCocoa
class HomeView: UIView {
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.spacing = 30
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(degreeLabel)
        stackView.addArrangedSubview(humidityLabel)
        
        self.addSubview(stackView)
        
        
    }
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            cityLabel.heightAnchor.constraint(equalToConstant: 200),
            cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            degreeLabel.heightAnchor.constraint(equalToConstant: 200),
            degreeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            degreeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            humidityLabel.heightAnchor.constraint(equalToConstant: 200),
            humidityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            humidityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        super.updateConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
