# Create Operator

RxSwift는 다양한 operator가 존재한다.
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

버튼을 누르면 결과로
Hello
completed
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

결과로
["Hello", "안녕"]
completed
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

결과는
Hello
안녕
completed
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

결과로
["Hello", "안녕"]
["World", "세상아"]
completed
가 나온다.

## from

from은 배열을 받아서 배열안의 요소를 각각 방출한다.
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

버튼을 누르면 결과로
1
2
3
4
5
completed
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

버튼을 누르면
1
2
3
4
5
completed
가 출력된다.

## generate

반복문에 대응하는 operator이다.
각각의 파라미터를 살펴보면,

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

버튼을 누르면 결과로
0
1
2
3
4
completed
가 나온다.


