//
//  APIManagerType.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import Foundation

enum NetworkError: Error {
    case networkError
    case fetchError
    case parsingError
}

protocol APIManagerType {
    typealias networkCompletion = (Result<Any, NetworkError>) -> Void
    func fetchData(city: String, apiType: String, completion: @escaping networkCompletion)
    func getData(urlString: String, apiType: String, completion: @escaping networkCompletion)
}
