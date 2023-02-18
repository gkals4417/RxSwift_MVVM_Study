# Create Operator

Operator는 Observable을 다루는 메서드들을 통칭하는 용어이다.<br/>
RxSwift는 다양한 operator가 존재한다.<br/>
큰 카테고리로 Create / Transform / Filter / Combine이 있다.

## just

아이템을 Observable로 변환시켜서 방출해준다.

```swfit
let observation = Observable.just("Hello")

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string)
    }
    .dispose()
}
```

버튼을 누르면 결과로<br/>
Hello<br/>
completed<br/>
가 출력된다.

just에 배열을 넣으면 어떻게 될까?

```swfit
let observation = Observable.just(["Hello", "안녕"])

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
        print(string)
    }
    .dispose()
}
```

결과로<br/>
["Hello", "안녕"]<br/>
completed<br/>
가 나온다.

just는 하나만 방출한다는 것을 기억해야 한다.

## of

of는 just와 비슷하지만, 하나만 방출하는 just와는 달리 of는 여러개를 방출할 수 있다.

```swfit
let observation = Observable.of("Hello", "안녕")

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
        print(string)
    }
    .dispose()
}
```

결과는<br/>
Hello<br/>
안녕<br/>
completed<br/>
가 나온다.

```swfit
let observation = Observable.of(["Hello", "안녕"], ["World", "세상아"])

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
        print(string)
    }
    .dispose()
}
```

결과로<br/>
["Hello", "안녕"]<br/>
["World", "세상아"]<br/>
completed<br/>
가 나온다.

## from

from은 배열을 받아서 배열안의 요소를 각각 방출한다.<br/>
방출되는 요소들 하나하나가 다 Observable임을 활용할 수 있다.

```swift
let observation = Observable.from([1, 2, 3, 4, 5])

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string)
    }
    .dispose()
}
```

버튼을 누르면 결과로<br/>
1<br/>
2<br/>
3<br/>
4<br/>
5<br/>
completed<br/>
가 나온다.

## range

시작점으로부터 1씩 증가하여 특정 갯수를 방출해준다.

```swift
let observation = Observable.range(start: 1, count: 5)

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe {string in
	print(string)
    }
    .dispose()
}
```

버튼을 누르면<br/>
1<br/>
2<br/>
3<br/>
4<br/>
5<br/>
completed<br/>
가 출력된다.

## generate

반복문에 대응하는 operator이다.<br/>
각각의 파라미터를 살펴보면,<br/>

1. initialState : 초기상태
2. condition : 현재 상태를 확인 후, true를 리턴하면 Observable을 진행하고, false를 리턴하면 Observable을 종료시킨다.
3. scheduler : 어떤 scheduler에서 실행시킬 것인지 정한다.
4. iterate : 이밴트가 발생된 후 매번 실행되는 구문<br/>
이다.

```swift
let observation = Observable.generate(
    initialState: 0,
    condition: { $0 < 5 },
    iterate: { $0 + 1 }
)

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string)
    }
    .dispose()
}
```

버튼을 누르면 결과로<br/>
0<br/>
1<br/>
2<br/>
3<br/>
4<br/>
completed<br/>
가 나온다.


## repeatElement

값을 동일하게 반복해서 방출해준다.<br/>
단순히 subscribe하면 무한정으로 방출을 해주지만, .take를 통해 횟수를 정해줄 수 있다.

```swift
let observation = Observable.repeatElement("Repeat")

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string)
    }
    .dispose()
}
```

위의 결과로는 Repeat이 무한정으로 계속 출력된다.

```swift
let observation = Observable.repeatElement("Repeat")

@IBAction func tapped(_ sender: UIButton) {
    observation
	.take(5)
	.subscribe { string in
        print(string)
    }
    .dispose()
}
```

위의 결과는<br/>
Repeat<br/>
Repeat<br/>
Repeat<br/>
Repeat<br/>
Repeat<br/>
completed<br/>
이다.

## deferred

deferred는 observer가 subscribe할 때까지 기다렸다가 구독을 하면 Observable을 생성하게 해준다.<br/>
이때 같은 Observable이 아니라 각각 다른 Observable을 가지게 된다.

```swift
let eng = ["one", "two", "three"]
let kor = ["일", "이", "삼"]
var lang = false

@IBAction func tapped(_ sender: UIButton) {
    lang.toggle()

    Observable.deferred {
	if self.lang {
	    return Observable.from(self.eng)
    	} else {
	    return Observable.from(self.kor)
    	}
    }
    .subscribe { string in
	print(string)
    }
}
```

위 코드를 설명하자면 영어와 한국어 두개의 배열이 있고, lang이라는 Bool이 있다.<br/>
버튼을 클릭할 때마다 lang은 false, true가 번갈아가며 바뀌게 되고, Observable.deferred를 통해 lang이 true일 때 from(self.eng) Observable을 리턴하고 lang이 false일 때 from(self.kor) Observable을 리턴한다.<br/>
마지막으로 Observable을 구독한다.

결과값으로 버튼을 누를 때마다<br/>
one<br/>
two<br/>
three<br/>
completed<br/>
일<br/>
이<br/>
삼<br/>
completed<br/>
를 반복한다.


## create

기존 연산자들은 Observable을 생성한다.<br/>
하지만 create를 사용하여 처음부터 Observable을 만들 수 있다.<br/>
create는 Disposable을 리턴하는 클로저를 전달하는데, onNext로 방출할 내용을 전달하면 된다.<br/>
onError, onCompleted를 이용해서 각 상황에 방출할 내용을 설정하면 된다.<br/>
중요한 것은 클로저 안에 Disposable을 리턴해야 한다는 것이다.<br/>

```swift
let observation: Observable<String?> = Observable.create { emitter in
    emitter.onNext("Hello")
    emitter.onNext("World")
    emitter.onCompleted()

    return Disposables.create()
}

@IBAction func tapped(_ sender: UIButton) {
    _ = observation.subscribe { string in
	print(string!)
    } onError: { error in
	print(error)
    } onCompleted: {
	print("completed")
    } onDisposed: {
	print("disposed")
    }
}
```

버튼을 누르면<br/>
Hello<br/>
World<br/>
completed<br/>
disposed<br/>
를 출력한다.


## empty / never / throw

empty : 방출되는 아이템이 없는 Observable을 만드는 operator. 정상적으로 종료가 된다.<br/>
never : 방출되는 아이템이 없는 Observable을 만드는 operator. 종료가 되지 않는다.<br/>
throw : 방출되는 아이템이 없는 Observable을 만든느 operator. error와 함께 종료가 된다. swift에서는 error로 적는다.

```swift
let observation : Observable<String?> = Observable.empty()

@IBAction func tapped(_ sender: UIButton) {
    _ = observation.subscribe { string in
	print(string!)
    } onError: { error in
	print(error)
    } onCompleted: {
	print("completed")
    } onDisposed: {
	print("disposed")
    }
}
```

버튼을 터치하면<br/>
completed<br/>
disposed<br/>
를 출력한다.

당연히 방출되는 아이탬이 없기 때문에 출력되는 이밴트는 없고, 정상적으로 종료가 되기 때문에 completed / disposed가 출력된다.

```swift
let observation : Observable<String?> = Observable.never()

@IBAction func tapped(_ sender: UIButton) {
    _ = observation.subscribe { string in
        print(string!)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }
}
```

버튼을 터치하더라도 아무것도 출력되지 않는다.<br/>
당연히 방출되는 아이탬이 없기 때문에 출력되는 이밴트도 없고, 종료가 되지 않기 때문에 completed 또는 disposed도 출력되지 않는다.

```swift
enum MyError: Error {
    case error
}

let observation : Observable<String?> = Observable.error(MyError.error)

@IBAction func tapped(_ sender: UIButton) {
    _ = observation.subscribe { string in
        print(string!)
    } onError: { error in
        print(error)
    } onCompleted: {
        print("completed")
    } onDisposed: {
        print("disposed")
    }
}
```

버튼을 터치하면<br/>
error<br/>
disposed<br/>
가 출력된다.

당연히 방출되는 아이템이 없기 때문에 출력되는 이밴트가 없고, error operator는 error와 함께 종료되기 때문에 onError의 error를 출력한다.
