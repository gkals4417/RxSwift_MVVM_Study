# Conditional Operator

## amb Operator

ambiguous의 약자로, 여러 Observable 중에서 가장 먼저 이벤트를 발생시킨 Observable의 이벤트들만 방출시킨다.<br/>

![amb](https://user-images.githubusercontent.com/70322435/221343920-ba0706ff-7b2a-4d1a-b35f-d2d0c44aa508.jpg)

![amb_xcode](https://user-images.githubusercontent.com/70322435/221343924-6e5f002f-171d-453e-949c-1a109c44f7b2.jpg)


```swift
@IBAction func tapped(_ sender: UIButton) {
    let firstObserver = PublishSubject<String>()
    let secondObserver = PublishSubject<String>()

    firstObserver
	.amb(secondObserver)
	.subscribe { print($0) }

    firstObserver.onNext("Hello")
    firstObserver.onNext("Hello2")
    secondObserver.onNext("GoodBye")
    firstObserver.onNext("Hello3")
    secondObserver.onNext("GoodBye2")
    secondObserver.onNext("GoodBye3")
}
```

Hello<br/>
Hello2<br/>
Hello3<br/>


```swift
@IBAction func tapped(_ sender: UIButton) {
    let firstObserver = PublishSubject<String>()
    let secondObserver = PublishSubject<String>()

    firstObserver
        .amb(secondObserver)
        .subscribe { print($0) }

    secondObserver.onNext("GoodBye")
    firstObserver.onNext("Hello")
    firstObserver.onNext("Hello2")
    firstObserver.onNext("Hello3")
    secondObserver.onNext("GoodBye2")
    secondObserver.onNext("GoodBye3")
}
```

GoodBye<br/>
GoodBye2<br/>
GoodBye3<br/>

위의 두 코드를 보면, 첫번째는 firstObserver가 가장 먼저 발생한 이벤트이기 때문에 Hello, Hello2, Hello3가 방출된 것이고,<br/>
두번째는 secondObserver가 가장 먼저 발생한 이벤트이기 때문에 GoodBye, GoodBye2, GoodBye3가 방출된 것이다.<br/>

