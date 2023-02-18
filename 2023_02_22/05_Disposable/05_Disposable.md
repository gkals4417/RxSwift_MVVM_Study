# Disposable

사전적 의미 : 사용 후 버리게 되어 있는, 일회용의

Observable은 subscribe를 하기 전까지 아무 작동도 하지 않는다.
그러다가 subscribe를 하는 순간 Observable의 onNext 이밴트를 방출한다.
이 방출은 onCompleted나 onError가 나기 전까지 계속 방출하게 되는데, subscribe를 해제하고 다음 이밴트를 발생시키지 않게 해주는 것이 바로 Disposable이다.
Observable은 Completed나 Error로 이밴트가 종료되며 자동으로 dipose된다. 하지만, RxSwift에서는 직접 dispose하는 것을 추천한다.

```swift
let observation: Observable<String?> = Observable.create { emitter in
    emitter.onNext("Hello")
    emitter.onNext("안녕")
    emitter.onCompleted()

    return Disposables.create()
}

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string!)
    } onError: { error in
	print(error)
    } onCompleted: {

    } onDisposed: {
	print("Disposed")
    }
    .dispose()
}
```

Observable에서 Hello와 안녕이라는 이밴트가 방출되고, 완료가 된다.
그리고 버튼을 누르면, observation을 subscribe하게 되는데, Observable의 두 이밴트를 방출 후, onCompleted를 하고, onDisposed를 통해 Dispose가 될 때  "Disposed"를 프린트하면서 observation 구독을 해제하게 된다.

그렇다면 각각의 subscribe마다 dispose를 관리해야 할까?
그런 번거로움을 줄이기 위해서 필요한 것이 바로 **DisposeBag**이다.
Bag이라는 단어 그대로 Disposable들을 담을 수 있는 클래스이다.
Disposable에서 disposed(by:) 메서드를 호출하면 된다.

```swift
let observation: Observable<String?> = Observable.create { emitter in
    emitter.onNext("Hello")
    emitter.onNext("안녕")
    emitter.onCompleted()

    return Disposables.create()
}

let disposeBag = DisposeBag()

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string!)
    } onError: { error in
	print(error)
    } onCompleted: {

    } onDisposed: {
	print("Disposed")
    }
    .disposed(by: disposeBag)
}
```

왜 귀찮데 Dispose를 해야 할까?
결국은 Memory Leak 때문이다.
만약 Observable에서 onNext만 존재하고, subscribe에서 dispose하지 않는다면 계속 메모리에서 해제되지 않고 계속 남아있게 된다.
그렇기 때문에 꼭 Dispose를 해야 한다.
