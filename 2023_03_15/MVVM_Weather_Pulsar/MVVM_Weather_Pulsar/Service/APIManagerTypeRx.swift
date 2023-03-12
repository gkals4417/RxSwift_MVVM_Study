//
//  APIManagerType.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import Foundation
import RxSwift

protocol APIManagerTypeRx {
    func fetchCurrentData(city: String, apiType: String) -> Observable<CurrentWelcome>
    func fetchForeCastData(city: String, apiType: String) -> Observable<[ForeCastList]>
}
