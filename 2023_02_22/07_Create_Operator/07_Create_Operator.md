# Create Operator

Operator는 Observable을 다루는 메서드들을 통칭하는 용어이다.<br/>
RxSwift는 다양한 operator가 존재한다.<br/>
큰 카테고리로 Create / Transform / Filter / Combine이 있다.<br/>

## just

아이템을 Observable로 변환시켜서 방출해준다.<br/>
<img width="640" alt="just c" src="https://user-images.githubusercontent.com/70322435/219848925-75012b4e-0473-41ae-a637-e4ceb90c34b3.png">
![just_xcode](https://user-images.githubusercontent.com/70322435/219848841-b4785d32-6b9b-4d2c-8dac-ea2f62dd5b58.jpg)


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
가 출력된다.<br/>
<br/>
just에 배열을 넣으면 어떻게 될까?<br/>

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
가 나온다.<br/>
<br/>
just는 하나만 방출한다는 것을 기억해야 한다.<br/>

## of

of는 just와 비슷하지만, 하나만 방출하는 just와는 달리 of는 여러개를 방출할 수 있다.<br/>
![of_xcode](https://user-images.githubusercontent.com/70322435/219848867-dc4e92da-737a-410a-96a7-1d8eb9070ccd.jpg)

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
가 나온다.<br/>

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
가 나온다.<br/>

## from

from은 배열을 받아서 배열안의 요소를 각각 방출한다.<br/>
방출되는 요소들 하나하나가 다 Observable임을 활용할 수 있다.<br/>
<img width="640" alt="from c" src="https://user-images.githubusercontent.com/70322435/219848905-0621a919-1fa9-43dc-874f-7b05cd0853a4.png">
![from_xcode](https://user-images.githubusercontent.com/70322435/219848887-d8420121-37d2-4c7b-9cef-c5599888f8ca.jpg)

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
가 나온다.<br/>

## range

시작점으로부터 1씩 증가하여 특정 갯수를 방출해준다.<br/>
<img width="640" alt="range c" src="https://user-images.githubusercontent.com/70322435/219848949-653e5911-5d5b-4795-b0a0-4de54f487a1b.png">
![range_xcode](https://user-images.githubusercontent.com/70322435/219848944-2b42c5d0-cf59-4f87-a407-09deb6e021d5.jpg)

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
가 출력된다.<br/>

## generate

반복문에 대응하는 operator이다.<br/>
![generate_xcode](https://user-images.githubusercontent.com/70322435/219848970-5db12cd1-2522-48c2-bc41-0be895a0466c.jpg)
각각의 파라미터를 살펴보면,<br/>

1. initialState : 초기상태
2. condition : 현재 상태를 확인 후, true를 리턴하면 Observable을 진행하고, false를 리턴하면 Observable을 종료시킨다.
3. scheduler : 어떤 scheduler에서 실행시킬 것인지 정한다.
4. iterate : 이밴트가 발생된 후 매번 실행되는 구문

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
가 나온다.<br/>

## repeatElement

값을 동일하게 반복해서 방출해준다.<br/>
단순히 subscribe하면 무한정으로 방출을 해주지만, .take를 통해 횟수를 정해줄 수 있다.<br/>
<img width="640" alt="repeat c" src="https://user-images.githubusercontent.com/70322435/219848992-5ebf1542-4a54-4ab8-a319-fd9f6c496420.png">
![repeatElement_xcode](https://user-images.githubusercontent.com/70322435/219848996-3c7d6277-56b6-47fd-b22d-798697da152e.jpg)

```swift
let observation = Observable.repeatElement("Repeat")

@IBAction func tapped(_ sender: UIButton) {
    observation.subscribe { string in
	print(string)
    }
    .dispose()
}
```

위의 결과로는 Repeat이 무한정으로 계속 출력된다.<br/>

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
이다.<br/>

## deferred

deferred는 observer가 subscribe할 때까지 기다렸다가 구독을 하면 Observable을 생성하게 해준다.<br/>
이때 같은 Observable이 아니라 각각 다른 Observable을 가지게 된다.<br/>
<img width="640" alt="defer c" src="https://user-images.githubusercontent.com/70322435/219849018-653ea2d8-a90c-4698-a17f-0f4da2a0d4ad.png">
![deferred_xcode](https://user-images.githubusercontent.com/70322435/219849022-43360313-2879-4a08-9f89-b8c6065f7457.jpg)

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
마지막으로 Observable을 구독한다.<br/>

결과값으로 버튼을 누를 때마다<br/>
one<br/>
two<br/>
three<br/>
completed<br/>
일<br/>
이<br/>
삼<br/>
completed<br/>
를 반복한다.<br/>


## create

기존 연산자들은 Observable을 생성한다.<br/>
하지만 create를 사용하여 처음부터 Observable을 만들 수 있다.<br/>
create는 Disposable을 리턴하는 클로저를 전달하는데, onNext로 방출할 내용을 전달하면 된다.<br/>
onError, onCompleted를 이용해서 각 상황에 방출할 내용을 설정하면 된다.<br/>
중요한 것은 클로저 안에 Disposable을 리턴해야 한다는 것이다.<br/>
<img width="640" alt="create c" src="https://user-images.githubusercontent.com/70322435/219849043-f2df18e6-3e2d-4f89-ab57-2ae9397951de.png">
![create_xcode](https://user-images.githubusercontent.com/70322435/219849047-c54c0f9b-5400-4347-bd07-47259019081b.jpg)

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
를 출력한다.<br/>


## empty / never / throw

empty : 방출되는 아이템이 없는 Observable을 만드는 operator. 정상적으로 종료가 된다.<br/>
![empty_xcode](https://user-images.githubusercontent.com/70322435/219849060-ed3a0ae9-afd9-4967-9e6a-bda5629b02d6.jpg)

never : 방출되는 아이템이 없는 Observable을 만드는 operator. 종료가 되지 않는다.<br/>
![never_xcode](https://user-images.githubusercontent.com/70322435/219849062-48ec0953-4a53-4aae-9057-0d695b37c4bc.jpg)

throw : 방출되는 아이템이 없는 Observable을 만든느 operator. error와 함께 종료가 된다. swift에서는 error로 적는다.<br/>
![error_xcode](https://user-images.githubusercontent.com/70322435/219849064-b591d775-7eb6-482c-8fae-e341cb790ff7.jpg)

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
를 출력한다.<br/>

당연히 방출되는 아이탬이 없기 때문에 출력되는 이밴트는 없고, 정상적으로 종료가 되기 때문에 completed / disposed가 출력된다.<br/>

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
당연히 방출되는 아이탬이 없기 때문에 출력되는 이밴트도 없고, 종료가 되지 않기 때문에 completed 또는 disposed도 출력되지 않는다.<br/>

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
가 출력된다.<br/>
<br/>
당연히 방출되는 아이템이 없기 때문에 출력되는 이밴트가 없고, error operator는 error와 함께 종료되기 때문에 onError의 error를 출력한다.<br/>
