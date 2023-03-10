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
    
    var currentWeatherData: CurrentWelcome? {
        var returnData: CurrentWelcome?
        apiManager.fetchData(city: city, apiType: "Current") { result in
            switch result {
            case .success(let successData):
                returnData = successData as? CurrentWelcome
            case .failure(let error):
                print(error)
            }
        }
        return returnData
    }

    var foreCastWeatherData: [ForeCastList]? {
        var returnData: [ForeCastList]?
        apiManager.fetchData(city: city, apiType: "ForeCast") { result in
            switch result {
            case .success(let successData):
                returnData = successData as? [ForeCastList]
            case .failure(let error):
                print(error)
            }
        }
        return returnData
    }

    
    init(apiManager: APIManagerType = APIManager.shared, city: String) {
        self.apiManager = apiManager
        self.city = city
    }
    
}

extension WeatherViewModel {
    func configure(_ view: UIView) {
        
    }
}
