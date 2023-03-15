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
   
    //ViewModel 인스턴스가 생성될 때 api 데이터를 받아옴
    init(apiManagerRx: APIManagerTypeRx = APIManagerRx.shared, cityRx: String) {
        self.apiManagerRx = apiManagerRx
        self.cityRx = cityRx
        currentWeatherDataRx = apiManagerRx.fetchCurrentData(city: cityRx, apiType: "Current")
        foreCastWeatherDataRx = apiManagerRx.fetchForeCastData(city: cityRx, apiType: "ForeCast")
    }
}


