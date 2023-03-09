//
//  FirstViewController.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit

class FirstViewController: UIViewController {

    let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        apiManager.fetchData(city: "Seoul", apiType: "ForeCast") { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    

}
