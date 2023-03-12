//
//  WeatherViewModelRx.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/12.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewModelRx {
    let apiManagerRx: APIManagerTypeRx
    private let disposeBag = DisposeBag()
    let cityRx: String
    
    let currentWeatherDataRx: Observable<CurrentWelcome>
    let foreCastWeatherDataRx: Observable<[ForeCastList]>
   
    init(apiManagerRx: APIManagerTypeRx = APIManagerRx.shared, cityRx: String) {
        self.apiManagerRx = apiManagerRx
        self.cityRx = cityRx
        currentWeatherDataRx = apiManagerRx.fetchCurrentData(city: cityRx, apiType: "Current")
            .asObservable()
        foreCastWeatherDataRx = apiManagerRx.fetchForeCastData(city: cityRx, apiType: "ForeCast")
            .asObservable()
    }
    
    private func fetchAPIDataRx() {
        
    }
}


