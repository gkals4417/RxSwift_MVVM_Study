# Infallible

사전적 의미 : 결코 틀리지 않는, 틀림없는, 전혀 오류가 없는<br/>
<br/>
InFallible은 Observable과 비슷한 형태이다.<br/>
그렇기 때문에 이벤트를 방출하게 되는데, Observable과는 다르게 Next와 Completed만 방출하고 Error는 방출하지 않음을 보장한다.<br/>

![Infallible_subscribe](https://user-images.githubusercontent.com/70322435/219848626-79e65c6c-5832-44ed-bba0-4c8d55a99db6.jpg)


```swift
@IBAction func tapped(_ sender: UIButton) {
    _ = observeFunc()
	.subscribe { onNext: { string in
	    print(string!)
	}, onCompleted: {

	}, onDisposed: {

	})
}

func observeFunc() -> Infallible<String?> {
    return Infallible.create { emitter in
	emitter(.next("Hello"))
	emitter(.completed)

	return Disposables.create()
    }
}
```
