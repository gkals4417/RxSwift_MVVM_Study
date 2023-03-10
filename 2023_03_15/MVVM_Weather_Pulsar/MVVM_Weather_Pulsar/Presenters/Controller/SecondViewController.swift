//
//  SecondViewController.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit

class SecondViewController: UIViewController {

//    private let apiManager = APIManager()
    
    var foreCastData: [ForeCastList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
//        apiManager.fetchData(city: "Paris", apiType: "ForeCast") { result in
//            switch result {
//            case .success(let data):
//                self.foreCastData = data as? [ForeCastList]
//                print(self.foreCastData)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }


}
