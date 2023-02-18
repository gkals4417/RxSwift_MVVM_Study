# Subject

Subject는 observer나 Observable처럼 작동한다.
Subject를 subscribe하고 Subject로부터 이밴트를 전달받는다.

다른 Observable을 subscribe하지 못하는 Observable과는 다르게, Subject는 다른 Observable에서 받은 이밴트를 자신의 구독자에게 방출할 수 있다.

## AsyncSubject

AsyncSubject는 Observable이 completed되는 순간 구독자에게 마지막 이밴트를 방출한다.
만약 Observable이 completed되지 않고 Error가 발생할 경우, AsyncSubject는 Error 이밴트를 방출한다..

```swift
let observation: AsyncSubject<String?> = AsyncSubject<String?>()

@IBAction func tapped(_ sender: UIButton) {
    observation.onNext("First")
//1.	observation.onCompleted()
    let firstSubscription = observation.subscribe { string in 
	print(string!)
    }

    observation.onNext("Second")
//2.	observation.onCompleted()
    observation.onNext("Third")

    let secondSubscription = observation.subscribe { string in
	print(string!)
    }
//3.	observation.onCompleted()

}
```

위의 코드에서 주석으로 처리한 1, 2, 3번의 onCompleted()를 번갈아가며 주석해제 후 실행을 해보면
1번 : First
2번 : Second
3번 : Third
가 프린트되는 것을 확인할 수 있다.

AsyncSubject는 completed되는 순간 마지막의 이밴트를 방출하기 때문에, 1번 completed의 마지막 이벤트는 First, 2번 completed의 마지막 이밴트는 Second, 3번 completed의 마지막 이밴트는 Third가 되는 것이다.

## BehaviorSubject

BehaviorSubject를 subscribe하면, 가장 최신의 이밴트를 방출한다.
만약, 아직 아무것도 방출된 이밴트가 없다면 BehaviorSubject의 초기값을 방출하게 된다.

```swift
let observation: BehaviorSubject = BehaviorSubject(value: "Initial")
let disposeBag = DisposeBag()

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string)
    }
    .disposed(by: disposeBag)

    observation.onNext("First")
    observation.onNext("Second")

    observation.subscribe { string in
	print(string)
    }
    .disposed(by: disposeBag)
}
```

이 상태로 버튼을 누르면
Initial
First
Second
second
가 출력된다.

왜일까?
먼저, observation을 구독하는 순간, 아직 아무것도 방출된 이밴트가 없기 때문에 Initial이라는 초기값을 방출한다.
그리고 두개의 onNext인 First와 Second를 방출하게 되는데, 이후 또다시 observation을 구독하면 마지막 이밴트였던 Second를 방출하게 된다.

만약 completed되거나 error가 발생할 경우, 그에 해당하는 이밴트를 방출한다.

## PublishSubject

PublishSubject는 subscribe 이후에 발생된 이밴트를 구독자에게 방출한다.
즉, 구독하기 이전에 발생한 이밴트를 알 수 없게 된다.

```swift
let observation: PublishSubject<String?> = PublishSubject<String?>()
let disposeBag = DisposeBag()

@IBAction func tapped(_ sender: UIButton) {
    observation.onNext("First")

    let one = observation.subscribe {string in 
	print(string!)
    }

    observation.onNext("Second")
    observation.onNext("Third")

    let two = observation.subscribe {string in
	print(string!)
    }

    observation.onNext("Fourth")

    one.disposed(by: disposeBag)
    two.disposed(by: displseBag)
}
```

이 상태로 버튼을 누르면
Second
Third
Fourth
Fourth
가 출력된다.

subscribe 이전에 발생한 이밴트인 First는 PublishSubject에서는 방출하지 않는다.
그래서 첫번째 구독인 one 이후에 발생한 이밴트, Second, Third, Fourth가 출력된다.
또한, 두번째 구독인 two 이후에 발생한 이밴트는 Fourth만 있기 때문에 종합적으로 Second, Third, Fourth, Fourth가 출력되는 것을 알 수 있다.

만약 completed되거나 error가 발생할 경우, 그에 해당하는 이밴트를 방출한다.

## ReplaySubject

ReplaySubject는 어떤 시점에서 subscribe를 하던지간에 subscribe한 순간 이전의 모든 이밴트들을 방출한다.
딱 들어도 잘못하면 메모리에 문제가 생길수도 있다는 느낌이 온다. 이때 몇 개의 이밴트 방출할 것인지 미리 설정할 수도 있는데, bufferSize를 통해 설정하면 된다
그리고 onNext 메서드를 여러 쓰레드에서 요청하지 말아야 하는 주의점도 있다.

```swift
let observation = ReplaySubject<String>.create(bufferSize: 3)
let disposeBag = DisposeBag()

@IBAction func tapped(_ sender: UIButton) {
    observation.onNext("First")

    let one = observation.subscribe { string in
	print(string)
    }

    observation.onNext("Second")
    observation.onNext("Third")

    let two = observation.subscribe { string in
	print(string)
    }

    observation.onNext("Fourth")

    one.disposed(by: disposeBag)
    two.disposed(by: disposeBag)
}
```

버튼을 누른 결과는
First
Second
Third
First
Second
Third
Fourth
Fourth
이다.

one이 구독을 하기 이전에 생성된 이밴트는 First이다. 그래서 First가 출력되고 그 다음 이밴트인 Second와 Third가 차례로 출력된다. 그리고 이후 이밴트인 Fourth가 출력된다.
그런데 two이 구독을 하면서 이전에 발생했던 이밴트들인 First, Second, Third가 다시 출력된다. 그리고 이후의 Fourth가 출력되게 된다.

## Relay

Relay는 Subject를 래핑하고 있는 클래스이다.
Subject와 비슷하지만 가장 큰 차이점이 두개가 있는데,
1. 사용자가 dispose하기 전까지 절대 complete되지 않는다.
2. 절대 error를 방출하지 않는다.
이다. 즉, Relay는 next 이밴트만 방출하고, 절대 종료되지 않는다.
크게 BehaviorRelay, PublishRelay, ReplayRelay 세 종류가 있다.
