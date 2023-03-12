//
//  FirstViewController.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import UIKit
import RxCocoa
import RxSwift

final class FirstViewController: UIViewController {
    
    //let myView = HomeView()
    let myCollectionView = HomeViewRx()
    //let viewModel = WeatherViewModel(city: "Seoul")
    let viewModelRx = WeatherViewModelRx(cityRx: "Seoul")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        myCollectionView.collectionView.delegate = self
        myCollectionView.collectionView.dataSource = self
        self.view.addSubview(myCollectionView)
        constraintSetup()
    }
    
    func constraintSetup() {
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            myCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            myCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            myCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0)
        ])
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeViewCell", for: indexPath) as! HomeVIewCell
        switch indexPath.row {
        case 0 :
            self.viewModelRx.currentWeatherDataRx.subscribe { result in
                DispatchQueue.main.async {
                    cell.cityLabel.text = result.name
                    cell.degreeLabel.text = "\(result.main.temp) 도"
                    cell.humidityLabel.text = "\(result.main.humidity) %"
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("SecondVC onCompleted")
            } onDisposed: {
                print("SecondVC onDisposed")
            }
            .disposed(by: disposeBag)
        case 1 :
            self.viewModelRx.foreCastWeatherDataRx.subscribe { result in
                DispatchQueue.main.async {
                    cell.cityLabel.text = result[7].dtTxt
                    cell.degreeLabel.text = "\(result[7].main.temp) 도"
                    cell.humidityLabel.text = "\(result[7].main.humidity) %"
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("FirstVC onCompleted")
            } onDisposed: {
                print("FirstVC onDisposed")
            }
        case 2 :
            self.viewModelRx.foreCastWeatherDataRx.subscribe { result in
                DispatchQueue.main.async {
                    cell.cityLabel.text = result[15].dtTxt
                    cell.degreeLabel.text = "\(result[15].main.temp) 도"
                    cell.humidityLabel.text = "\(result[15].main.humidity) %"
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("FirstVC onCompleted")
            } onDisposed: {
                print("FirstVC onDisposed")
            }
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
