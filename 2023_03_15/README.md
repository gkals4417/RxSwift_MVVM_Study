# 2주차

## 목표 난이도를 낮춤

모두가 만들 수 있는 주제를 정한 뒤, MVVM, RXSwift를 사용하여 앱 제작하기로 변경.<br/>

## API

[API](https://openweathermap.org/api)를 이용하여 앱 제작<br/>

## UI

Storyboard, Xib, 코드베이스(SnapKit, FlexLayout) 등 각자 편한 방법을 이용한다.

## View

2개의 TabBarController<br/>
각 탭마다 지역을 고정<br/>
<br/>

### 첫번째 탭

지역 : 서울<br/>
화면 : 좌-우 탭을 통해 어제, 오늘, 내일 날씨 보여주기<br/>

### 두번째 탭

지역 : 해외<br/>
화면 : 좌-우 탭을 통해 어제, 오늘, 내일 날씨 보여주기<br/>

## Architecture

MVVM <br/>

### 파일 트리

<img width="260" alt="스크린샷 2023-03-08 오후 8 56 21" src="https://user-images.githubusercontent.com/70322435/223883395-040db3fa-7038-491f-aa75-79600525b04b.png">

---

>2023년 3월 15일까지 제작 후 발표.<br/>
일주일동안 공부한 내용 이야기하기<br/>
만약 완성하지 못했다면, 각자 이야기를 하면서 완성해주기<br/>

---

>2023년 3월 13일 제작 완료

# 코드 설명

## 폴더 트리

![2023-03-13_18-30-06](https://user-images.githubusercontent.com/70322435/224662034-3e4f71c3-e8d0-43aa-a86e-43bb6bcda07b.jpg)

두 가지 버전으로 제작했다.<br/>
하나는 RxSwift를 사용하지 않은 버전이고 다른 하나는 RxSwift를 사용한 버전이다.<br/>
viewModel, View, Service 폴더에 있는 swift 파일들 중, 뒤에 Rx라고 붙여있는 것이 RxSwift를 사용한 버전이다.<br/>

## API

사용하려고 한 API인 openWeather에서 current weather와 5day weather forecast 두 개의 API를 사용하였다.<br/>
그 때문에 Service에서 데이터를 받으려는 메서드를 두 개 만들었다.<br/>

먼저 의존성 주입을 위한 APIManagerType 프로토콜을 만들었다.<br/>
```swift
protocol APIManagerTypeRx {
    func fetchCurrentData(city: String, apiType: String) -> Observable<CurrentWelcome>
    func fetchForeCastData(city: String, apiType: String) -> Observable<[ForeCastList]>
}
```
현재 날씨 데이터를 얻을 수 있는 메서드와 예보 데이터를 얻을 수 있는 메서드 두개인데, 각각 API에서 요구하는 Model을 Observable로 리턴하도록 했다.<br/>
(우리가 화면에 보여줄 내용은 결국 날씨 데이터이기 때문에 날씨 데이터를 Observable로 설정해, 값이 바뀌면 화면에 바로 내용이 바뀌어야 한다.)<br/>

```swift
func fetchCurrentData(city: String, apiType: String) -> Observable<CurrentWelcome> {
    let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
    print(urlString)
        
    guard let url = URL(string: urlString) else {
        return Observable.error(NSError(domain: "invalid_url", code: 0))
    }
        
    let request = URLRequest(url: url)
        
    return URLSession.shared.rx.data(request: request)
        .map{try JSONDecoder().decode(CurrentWelcome.self, from: $0)}
        .asObservable()
    }
```

위 메서드는 현재 데이터를 얻기 위한 메서드이다.<br/>
(예보 데이터를 얻는 메서드도 거의 동일하다.)<br/>
메서드의 상단부분은 외부 데이터를 얻기 위한 평범한 형태이다.<br/>
함수의 리턴부분이 RxSwift를 사용한 부분인데, URLSession의 Reactive Extension인 rx가 붙어있다. 뒤의 data는 실제 데이터를 얻기 위한 메서드이다.<br/>
각각의 데이터를 .map을 통해 각각의 이벤트로 방출을 해준다. 이때, JSONDecoder()를 통해 데이터가 바뀌면서 방출된다.<br/>
마지막으로 asObservable()을 통해 각각의 이벤트들을 Observable로 바꿔주게 한다.<br/>

여기까지 API로 받은 데이터를 Observable로 리턴하는 메서드를 완성했다.<br/>

## ViewModel

여기 부분은 정확하게 했는지 잘 모르겠다.<br/>

```swift
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
        foreCastWeatherDataRx = apiManagerRx.fetchForeCastData(city: cityRx, apiType: "ForeCast")
    }
}
```

ViewModel에서는 APIManager를 통해 데이터를 실제로 받게 설정했다.<br/>
생성자를 통해 ViewModel 인스턴스가 만들어지면 자동으로 각각의 속성에 실제 데이터를 받아서 저장하게 했다.<br/>

---

## View

탭 하나마다 도시 하나의 현재, 내일, 모레 날씨를 넣어야 했기 때문에 CollectionView를 사용해야 했다.<br/>
그렇기 때문에 HomeViewCell.swift를 통해 CollectionView에 들어갈 Cell의 모습을 설정했고, HomeViewRx.swift를 통해 CollectionView의 모습을 설정했다.<br/>

---

## ViewController

ViewController에서는 View와 ViewModel 인스턴스를 생성해서, ViewModel에 있는 데이터를 View에게 보여주는 역할을 한다.<br/>

```swift
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
        return collectionView.frame.size
    }
}
```

특히 ViewController를 확장해서 CollectionView의 DataSource, Delegate, DelegateFlowLayout 프로토콜을 채택해서 CollectionView를 설정했다.<br/>
여기서 봐야 하는 부분은 cellForItemAt 메서드이다.<br/>
여기서 indexPath.row를 switch 문으로 나누었는데, 애초의 목표가 총 3개의 Cell만 필요했고, 현재, 내일, 모레의 데이터를 보여준다는 목표가 있었기 때문에 case가 0, 1, 2일 때만 생각했다.<br/>
그리고, ViewModel에 있는 데이터를 subscribe한 뒤 label에 전달을 했는데, label의 경우 UI이기 때문에 메인쓰레드에서 작동을 해야 했다.<br/>
그래서 DispatchQueue.main.async를 통해 메인쓰레드에서 작동하게 만들었다.<br/>

---

>결과적으로 실시간으로 데이터를 받고 화면에 나오는 것까지 문제가 없다는 것을 확인했다.<br/>

![Simulator Screen Recording - iPhone 14 Pro - 2023-03-13 at 19 01 37](https://user-images.githubusercontent.com/70322435/224669524-48a42ae9-5f66-45ed-87df-c9e5223dc12b.gif)

---

## 어려웠던 점

처음 RxSwift와 MVVM 패턴을 사용하는 것이었기 때문에 모든것이 어색했다.<br/>
처음에는 MVVM 패턴만 사용하자는 목표로 제작을 했고, 이후에 RxSwift를 추가하는 방향을 선택했다.<br/>

가장 많이 해맸던 부분은, 어떻게 API로 받은 데이터들을 Observable로 감싸서 return할 수 있을지였다.<br/>
그러다가 알게 된 것이 **asObservable()**이었고, 이를 통해 해결할 수 있었다.<br/>

두번째로 해맸던 부분은, ViewController에서 어떻게 받은 데이터들을 세 화면으로 나누어서 보여줄까 하는 것이었다.<br/>
API Model을 자세히 보니 dtTxt라는 속성이 있었고, 그것이 날짜 및 시간이었다는 점, 그리고 예외없이 3시간 간격이었다는 점, 마지막으로 내가 필요했던 것은 현재, 내일, 모레 세 날짜만이라는 점이었다.<br/>
그래서 cell의 indexPath.row가 0, 1, 2일 때로 분기를 나누어서 해결할 수 있었다.<br/>

마지막으로 View와 ViewModel을 어떻게 분리해야 하는지였다.<br/>
결국 View는 화면에 보여주기 위해 필요한 것들만 넣었고, ViewModel에는 화면에 보여주는 데이터들을 보관하는 용도로 세팅했다.<br/>

---
