//
//  WeatherViewModel.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/10.
//

import UIKit

class WeatherViewModel {
    
    let apiManager: APIManagerType
    let city: String
    
    var currentWeatherData: CurrentWelcome?
    var foreCastWeatherData: [ForeCastList]?

    init(apiManager: APIManagerType = APIManager.shared, city: String) {
        self.apiManager = apiManager
        self.city = city
        fetchAPIData()
    }
    private func fetchAPIData() {
        self.currentWeatherData = {
            self.apiManager.fetchData(city: self.city, apiType: "Current") { result in
                switch result {
                case .success(let successData):
                    //print("Current \(successData)")
                    self.currentWeatherData = successData as! CurrentWelcome?
                case .failure(let error):
                    print(error)
                }
            }
            return nil
        }()
        
        self.foreCastWeatherData = {
            self.apiManager.fetchData(city: self.city, apiType: "ForeCast") { result in
                switch result {
                case .success(let successData):
                    //print("ForeCast \(successData)")
                    self.foreCastWeatherData = successData as! [ForeCastList]?
                case .failure(let error):
                    print(error)
                }
            }
            return nil
        }()
    }
}

extension WeatherViewModel {
    func configure(_ view: HomeView) {
        DispatchQueue.main.async {
            view.cityLabel.text = self.city
            view.degreeLabel.text = "\(String(describing: self.currentWeatherData?.main.temp))"
            view.humidityLabel.text = "\(String(describing: self.foreCastWeatherData?[0].main.humidity))"
        }
    }
}
