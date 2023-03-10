//
//  APIManager.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit

struct APIManager: APIManagerType {
    
    static let shared = APIManager()
    
    func fetchData(city: String, apiType: String, completion: @escaping networkCompletion) {
        var urlString = ""
        
        if apiType == "Current" {
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        } else {
            urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)"
        }
        print(urlString)
        getData(urlString: urlString, apiType: apiType) { result in
            completion(result)
        }
    }
    
    func getData(urlString: String, apiType: String, completion: @escaping networkCompletion) {
        guard let url = URL(string: urlString) else { return }
        
        let sesstion = URLSession(configuration: .default)
        
        let request = URLRequest(url: url)
        
        let task = sesstion.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
                print(error!)
                return
            }
            
            guard let safeData = data else {
                print("ERROR: Data Error")
                completion(.failure(.fetchError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("ERROR: Request Error")
                return
            }
            
            if apiType == "Current" {
                if let myData = self.parseCurrentJSON(safeData) {
                    print("Success parse")
                    completion(.success(myData))
                } else {
                    print("Failed parse Current")
                    completion(.failure(.parsingError))
                }
            } else {
                if let myData = self.parseForeCastJSON(safeData) {
                    print("Success parse")
                    completion(.success(myData))
                } else {
                    print("Failed parse ForeCast")
                    completion(.failure(.parsingError))
                }
            }
        }
        task.resume()
    }

    private func parseCurrentJSON(_ data: Data) -> CurrentWelcome? {
        do {
            let myData = try JSONDecoder().decode(CurrentWelcome.self, from: data)
            print(myData)
            return myData
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func parseForeCastJSON(_ data: Data) -> [ForeCastList]? {
        do {
            let myData = try JSONDecoder().decode(ForeCastWelcome.self, from: data)
            print(myData.list)
            return myData.list
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
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
}


