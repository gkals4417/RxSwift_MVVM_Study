//
//  FirstViewController.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit
import RxCocoa
import RxSwift

class FirstViewController: UIViewController {
    
    let myView = HomeView()
    let viewModel = WeatherViewModel(city: "Seoul")
    let viewModelRx = WeatherViewModelRx(cityRx: "Seoul")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray

        viewModelRx.currentWeatherDataRx.subscribe { result in
            DispatchQueue.main.async {
                self.myView.cityLabel.text = result.name
                self.myView.degreeLabel.text = "\(result.main.temp)"
                self.myView.humidityLabel.text = "\(result.main.humidity)"
            }
            
        } onError: { error in
            print(error)
        } onCompleted: {
            
        } onDisposed: {
            
        }
        .disposed(by: disposeBag)

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
