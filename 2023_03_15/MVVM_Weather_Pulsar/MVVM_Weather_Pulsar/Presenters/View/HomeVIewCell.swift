//
//  HomeVIewCell.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/12.
//

import UIKit

class HomeVIewCell: UICollectionViewCell {
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
            degreeLabel.heightAnchor.constraint(equalToConstant: 200),
            degreeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            humidityLabel.heightAnchor.constraint(equalToConstant: 200),
            humidityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor)
        ])
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
