//
//  FirstViewController.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit

class FirstViewController: UIViewController {

//    private let apiManager = APIManager()
    
    var currentData: CurrentWelcome?
    
    let viewModel = WeatherViewModel(city: "Seoul")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        DispatchQueue.global().async {
            print(self.viewModel.currentWeatherData)
            print(self.viewModel.foreCastWeatherData)
        }
        
//        apiManager.fetchData(city: "Seoul", apiType: "Current") { result in
//            switch result {
//            case .success(let data):
//                self.currentData = data as? CurrentWelcome
//                print(self.currentData)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
    
    

}
