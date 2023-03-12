//
//  APIManager.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit
import RxSwift

struct APIManagerRx: APIManagerTypeRx {

    static let shared = APIManagerRx()
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else {
                fatalError("Couldn't find file 'APIKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'APIKEY.plist'.")
            }
            return value
        }
    }
    
    func fetchCurrentData(city: String, apiType: String) -> Observable<CurrentWelcome> {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "invalid_url", code: 0))
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
            .retry(3)
            .map{try JSONDecoder().decode(CurrentWelcome.self, from: $0)}
            .asObservable()
    }
    
    func fetchForeCastData(city: String, apiType: String) -> Observable<[ForeCastList]> {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "invalid_url", code: 0))
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.data(request: request)
            .retry(3)
            .map{ try JSONDecoder().decode(ForeCastWelcome.self, from: $0).list}
            .asObservable()
    }
}


