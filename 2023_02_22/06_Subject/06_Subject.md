# Subject

Subject는 observer나 Observable처럼 작동한다.<br/>
Subject를 subscribe하고 Subject로부터 이벤트를 전달받는다.<br/>
<br/>
다른 Observable을 subscribe하지 못하는 Observable과는 다르게, Subject는 다른 Observable에서 받은 이벤트를 자신의 구독자에게 방출할 수 있다.<br/>

## AsyncSubject

AsyncSubject는 Observable이 completed되는 순간 구독자에게 마지막 이벤트를 방출한다.<br/>
<img width="640" alt="S AsyncSubject" src="https://user-images.githubusercontent.com/70322435/219848700-69a72c1f-f68a-496e-aebd-fee04209c9fe.png">

만약 Observable이 completed되지 않고 Error가 발생할 경우, AsyncSubject는 Error 이벤트를 방출한다.<br/>
<img width="640" alt="S AsyncSubject e" src="https://user-images.githubusercontent.com/70322435/219848705-89cf1b1f-0d7f-46a5-9cbf-64bc9b4842ff.png">


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

위의 코드에서 주석으로 처리한 1, 2, 3번의 onCompleted()를 번갈아가며 주석해제 후 실행을 해보면<br/>
1번 : First<br/>
2번 : Second<br/>
3번 : Third<br/>
가 프린트되는 것을 확인할 수 있다.<br/>
<br/>
AsyncSubject는 completed되는 순간 마지막의 이벤트를 방출하기 때문에, 1번 completed의 마지막 이벤트는 First, 2번 completed의 마지막 이벤트는 Second, 3번 completed의 마지막 이벤트는 Third가 되는 것이다.<br/>

## BehaviorSubject

BehaviorSubject를 subscribe하면, 가장 최신의 이벤트를 방출한다.<br/>
<img width="640" alt="S BehaviorSubject" src="https://user-images.githubusercontent.com/70322435/219848737-7f89080d-510d-477b-bb10-67fc479df184.png">

만약, 아직 아무것도 방출된 이벤트가 없다면 BehaviorSubject의 초기값을 방출하게 된다.<br/>
<img width="640" alt="S BehaviorSubject e" src="https://user-images.githubusercontent.com/70322435/219848740-84ba0880-5247-4946-a8d3-b1bdbe066515.png">

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

이 상태로 버튼을 누르면<br/>
Initial<br/>
First<br/>
Second<br/>
second<br/>
가 출력된다.<br/>

왜일까?<br/>
먼저, observation을 구독하는 순간, 아직 아무것도 방출된 이벤트가 없기 때문에 Initial이라는 초기값을 방출한다.<br/>
그리고 두개의 onNext인 First와 Second를 방출하게 되는데, 이후 또다시 observation을 구독하면 마지막 이벤트였던 Second를 방출하게 된다.<br/>
<br/>
만약 completed되거나 error가 발생할 경우, 그에 해당하는 이벤트를 방출한다.<br/>

## PublishSubject

PublishSubject는 subscribe 이후에 발생된 이벤트를 구독자에게 방출한다.<br/>
즉, 구독하기 이전에 발생한 이벤트를 알 수 없게 된다.<br/>
<img width="640" alt="S PublishSubject" src="https://user-images.githubusercontent.com/70322435/219848768-da71e763-e1fa-4c73-b26c-446e9ac826f7.png">
<img width="640" alt="S PublishSubject e" src="https://user-images.githubusercontent.com/70322435/219848770-ba4defa5-01a6-4462-8950-419e0255c9fe.png">

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

이 상태로 버튼을 누르면<br/>
Second<br/>
Third<br/>
Fourth<br/>
Fourth<br/>
가 출력된다.<br/>
<br/>
subscribe 이전에 발생한 이벤트인 First는 PublishSubject에서는 방출하지 않는다.<br/>
그래서 첫번째 구독인 one 이후에 발생한 이벤트, Second, Third, Fourth가 출력된다.<br/>
또한, 두번째 구독인 two 이후에 발생한 이벤트는 Fourth만 있기 때문에 종합적으로 Second, Third, Fourth, Fourth가 출력되는 것을 알 수 있다.<br/>
<br/>
만약 completed되거나 error가 발생할 경우, 그에 해당하는 이벤트를 방출한다.<br/>

## ReplaySubject

ReplaySubject는 어떤 시점에서 subscribe를 하던지간에 subscribe한 순간 이전의 모든 이벤트들을 방출한다.<br/>
딱 들어도 잘못하면 메모리에 문제가 생길수도 있다는 느낌이 온다. 이때 몇 개의 이벤트 방출할 것인지 미리 설정할 수도 있는데, bufferSize를 통해 설정하면 된다.<br/>
그리고 onNext 메서드를 여러 쓰레드에서 요청하지 말아야 하는 주의점도 있다.<br/>

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

버튼을 누른 결과는<br/>
First<br/>
Second<br/>
Third<br/>
First<br/>
Second<br/>
Third<br/>
Fourth<br/>
Fourth<br/>
이다.<br/>
<br/>
one이 구독을 하기 이전에 생성된 이벤트는 First이다. 그래서 First가 출력되고 그 다음 이벤트인 Second와 Third가 차례로 출력된다. 그리고 이후 이벤트인 Fourth가 출력된다.<br/>
그런데 two이 구독을 하면서 이전에 발생했던 이벤트들인 First, Second, Third가 다시 출력된다. 그리고 이후의 Fourth가 출력되게 된다.<br/>

## Relay

Relay는 Subject를 래핑하고 있는 클래스이다.<br/>
Subject와 비슷하지만 가장 큰 차이점이 두개가 있는데,<br/>
1. 사용자가 dispose하기 전까지 절대 complete되지 않는다.
2. 절대 error를 방출하지 않는다.

이다.<br/>
즉, Relay는 next 이벤트만 방출하고, 절대 종료되지 않는다.<br/>
크게 BehaviorRelay, PublishRelay, ReplayRelay 세 종류가 있다.<br/>
<img width="640" alt="S ReplaySubject" src="https://user-images.githubusercontent.com/70322435/219848803-b48e03a7-3957-40b6-8b0d-93fc5b6d4445.png">
