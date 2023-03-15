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
    //let viewModel = WeatherViewModel(city: "Seoul")
    
    //메인 화면 View
    let myCollectionView = HomeViewRx()
    
    //ViewModel 인스턴스
    let viewModelRx = WeatherViewModelRx(cityRx: "Seoul")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        //Current, 내일, 모레 날씨 세 화면
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeViewCell", for: indexPath) as! HomeVIewCell
        
        //첫번째 ~ 세번째 cell마다 보여줄 내용
        switch indexPath.row {
        case 0 :
            //ViewModel의 날씨 데이터 구독
            self.viewModelRx.currentWeatherDataRx.subscribe { result in
                //UI와 관련되어있기 때문에 메인쓰레드에서 진행
                DispatchQueue.main.async {
                    cell.cityLabel.text = "\(result.name) 의 현재 날씨"
                    cell.degreeLabel.text = "기온 : \(result.main.temp) 도"
                    cell.humidityLabel.text = "습도 : \(result.main.humidity) %"
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("FirstVC onCompleted")
            } onDisposed: {
                print("FirstVC onDisposed")
            }
            .disposed(by: disposeBag)
        case 1 :
            self.viewModelRx.foreCastWeatherDataRx.subscribe { result in
                DispatchQueue.main.async {
                    cell.cityLabel.text = "\(result[6].dtTxt) 의 예보"
                    cell.degreeLabel.text = "기온 : \(result[6].main.temp) 도"
                    cell.humidityLabel.text = "습도 : \(result[6].main.humidity) %"
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("FirstVC onCompleted")
            } onDisposed: {
                print("FirstVC onDisposed")
            }
            .disposed(by: disposeBag)
        case 2 :
            self.viewModelRx.foreCastWeatherDataRx.subscribe { result in
                DispatchQueue.main.async {
                    cell.cityLabel.text = "\(result[14].dtTxt) 의 예보"
                    cell.degreeLabel.text = "기온 : \(result[14].main.temp) 도"
                    cell.humidityLabel.text = "습도 : \(result[14].main.humidity) %"
                }
            } onError: { error in
                print(error)
            } onCompleted: {
                print("FirstVC onCompleted")
            } onDisposed: {
                print("FirstVC onDisposed")
            }
            .disposed(by: disposeBag)
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //cell 하나의 크기를 collectionView의 크기와 동일하게 변경
        //-> 한 화면에 cell 하나만 보임
        return collectionView.frame.size
    }
}
