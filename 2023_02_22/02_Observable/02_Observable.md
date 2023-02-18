# Observable

사전적 의미 : 식별할 수 있는

ReactiveX에서 옵저버는 Observable을 **subscribe**한다. 
그다음 옵저버는 Observable이 **방출**하는 항목들에게 반응한다.
Observable이 객체를 방출할 때까지 기다릴 필요가 없이, 방출되면 그 시점을 감시하는 관찰자를 두고 알림을 받으면 되기 때문에 **동시성 연산**을 가능하게 한다.

정리하면, Observable을 이용해서 적당한 이벤트 처리를 할 수 있게 된다.

Observable은 3개의 메서드를 구현할 수 있다.

## onNext

Observable은 새로운 항목들을 방출할 때마다 이 메서드를 호출한다.
Observable에 의해 방출된 항목을 파라미터로 가지게 된다.

## onError

예상되는 데이터를 생성하지 못했거나 무언가의 에러가 발생했을 때 호출되는 메서드이다.
더이상의 onNext나 onCompleted를 호출하지 않는다. 

## onCompleted

만약 에러가 없다면, 마지막으로 onNext 메서드가 불렸을 때 onCompleted를 호출한다.
onNext는 일반적으로 **방출**이라고 표현을 하지만, onCompleted나 onError는 notification으로 표현한다.

### Example

```swift
func observeFunc() -> Observable<String?> {
    return Observable.create {emitter in
	emitter.onNext("Hello")
	emitter.onCompleted()

	return Disposables.create()
    }
}
```

observeFunc()는 Observable<String?>을 리턴한다.
이때 .create를 통해 Observable을 생성하고, 그 안에 클로저로 onNext, onCompleted를 호출한다.
.create와 Disposable은 후에 설명할 예정이다.
