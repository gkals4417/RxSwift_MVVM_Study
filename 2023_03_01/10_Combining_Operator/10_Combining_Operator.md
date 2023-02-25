# Combining Operator

## startWith

Observable의 이벤트가 시작되기 전에, 특정 아이템을 방출한 뒤 Observable의 이벤트가 시작된다.<br/>

![startWith](https://user-images.githubusercontent.com/70322435/221329214-c0c09039-3295-43b2-b3ad-0a9fa29e7d34.jpg)

![startWith_xcode](https://user-images.githubusercontent.com/70322435/221329216-31b0c1ca-175d-40d9-88a3-014e0c6d4d6c.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observation
	.startWith(0)
	.subscribe { print($0) }
	.dispose()
}
```

위 코드에서 Observable의 이벤트는 각각 1, 2, 3, 4, 5를 순서대로 방출하는 것이다.<br/>
하지만, .startWith(0)를 통해 먼저 0을 방출한 뒤 나머지 이벤트를 진행하게 된다.<br/>
따라서 결과적으로<br/>
0<br/>
1<br/>
2<br/>
3<br/>
4<br/>
5<br/>
completed<br/>
이 된다.<br/>


## concat

2개 또는 그 이상의 Observable들의 이벤트들을 합쳐서 방출한다.<br/>
합쳐질 때, 첫번째 Observable에서 모든 방출이 마무리가 된 뒤 이어서 두번째 Observable의 이벤트가 방출된다.<br/>

![concat](https://user-images.githubusercontent.com/70322435/221329724-c99165e3-30fa-41dd-81b3-1d8655eff34b.jpg)

![concat_xcode](https://user-images.githubusercontent.com/70322435/221329725-aba22fad-9b99-4302-b1ec-6522ef25c757.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.of(1, 2, 3)
    let observationTwo = Observable.of(10, 20, 30)

    obervationOne
	.concat(observationTwo)
	.subscribe { print($0) }
	.dispose()
}
```
결과적으로 observationOne의 이벤트가 모두 마무리된 뒤 바로 observationTwo의 이벤트가 방출된다.<br/>
1<br/>
2<br/>
3<br/>
10<br/>
20<br/>
30<br/>
completed<br/>
가 나온다.<br/>


## merge

concat과 비슷하게 2개 또는 그 이상의 Observable을 합쳐서 방출한다.<br/>
하지만 concat과 다르게 합쳐질 때 순서는 먼저 발생하는 이벤트 순서대로이다.<br/>
만약 Error가 방출되는 경우, 그 즉시 merge를 멈추고 종료된다.<br/>

![merge](https://user-images.githubusercontent.com/70322435/221330608-ff4209bb-8958-4373-a295-a5fa62891b60.jpg)

![merge_xcode](https://user-images.githubusercontent.com/70322435/221330610-ef3ace37-fdf1-449c-b751-7b581b7feb59.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let color = PublishSubject<String>()
    let shape = PublishSubject<String>()
    let observation = Observable.merge(color, shape)

    observation
	.subscribe { print($0) }

    color.onNext("Red")
    color.onNext("Black")
    shape.onNext("Circle")
    color.onNext("Blue")
    color.onNext("Star")
}
```

두 개의 Observable이 있다. 하나는 color, 나머지 하나는 shape인데, merge를 통해 하나로 합친다.<br/>
color의 이벤트는 "Red", "Black", "Blue" 이고, shape의 이벤트는 "Circle", "Star"이다.<br/>
두 Observable의 merge의 결과는<br/>
Red<br/>
Black<br/>
Circle<br/>
Blue<br/>
Star<br/>
가 된다.<br/>


## combineLatest

두 Observable이 이벤트를 방출하고 있을 때, 두 Observable의 마지막 이벤트를 합치고, 결과를 방출해준다.<br/>
합쳐지는 방법은 1:1로 한번씩만 합쳐지는 것이 아니라, Observable의 이벤트가 있을 떄마다 합쳐진다.<br/>

![combineLatest](https://user-images.githubusercontent.com/70322435/221333154-24c48a1a-fa70-44de-9ee1-49c3130d84d8.jpg)

![combineLatest_xcode](https://user-images.githubusercontent.com/70322435/221333156-62a5b807-76e1-4d33-a6f3-a343f9d6c5ce.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let color = PublishSubject<String>()
    let shape = PublishSubject<String>()
    let observation = Observable.combineLatest(color, shape)

    observation
	.subscribe { print($0) }

    color.onNext("Red")
    color.onNext("Black")
    shape.onNext("Circle")
    color.onNext("Blue")
    color.onNext("Star")
}
```
두 Obsevable을 그림으로 나타내면 아래와 같다.<br/>

--Red--Black----------Blue------<br/>
--------------Circle-------Star--<br/>

Circle이라는 새로운 이벤트가 생기는 순간, Black과 Circle이 합쳐지고, 그 다음 이벤트인 Blue가 생기면 이전의 최근 이벤트인 Circle과 합쳐지게 된다.<br/>
Star 이벤트가 생기면 가장 최근 이벤트인 Blue와 합쳐지게 된다.<br/>
결과적으로<br/>
("Black", "Circle")<br/>
("Blue", "Circle")<br/>
("Blue", "Star")<br/>
가 된다.<br/>

## zip

combineLatest와 비슷하게, 두 Observable의 이벤트를 하나로 합쳐서 방출해준다. <br/>
하지만 zip은 순서대로 짝을 지어 방출하게 되고, 짝이 없는 나머지의 경우 방출되지 않고 작업이 끝나게 된다.<br/>

![zip](https://user-images.githubusercontent.com/70322435/221340898-a9a833a7-bf36-4361-80dd-1a5e78294a5e.jpg)

![2023-02-25_14-45-45](https://user-images.githubusercontent.com/70322435/221340900-0ad1363a-267a-4e87-8bd9-7a73474478b2.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.of(1, 2, 3)
    let observationTwo = Observable.of("A", "B", "C", "D")

    Observable
	.zip(observationOne, observationTwo)
	.subscribe { print($0) }
	.dispose()
}
```

위 코드를 해석하면, observationOne과 observationTwo의 이벤트들이 하나씩 짝을 지어 방출된다.<br/>
하지만, observationTwo의 "D"는 짝이 없기 때문에 방출되지 않고 작업이 끝난다.<br/>
결과적으로<br/>
(1, "A")<br/>
(2, "B")<br/>
(3, "C")<br/>
completed<br/>
이 출력된다.<br/>


## withLatestFrom

combineLatest와 비슷하지만, 첫번째 Observable의 이벤트가 없다면 방출하지 않고 다음으로 넘어가게 된다는 차이점이 있다.<br/>

![withLatestFrom_xcode](https://user-images.githubusercontent.com/70322435/221341346-81775b0b-3e85-449f-ba0b-0814a0309804.jpg)

## sample

withLatestFrom과 비슷하지만 같은 데이터를 연속해서 방출하지 않는다는 차이점이 있다.<br/>
완료시 마지막 남은 데이터를 방출하지 않고 completed된다.<br/>

![sample](https://user-images.githubusercontent.com/70322435/221341751-125ffc71-dd41-45f1-ba51-81cb35c678ff.jpg)

![sample_xcode](https://user-images.githubusercontent.com/70322435/221341753-397e5e28-8f42-489c-a01b-b69940b6a746.jpg)


```swift
@IBAction func tapped(_ sender: UIButton) {
    let color = PublishSubject<String>()
    let shape = PublishSubject<String>()

    color
	.sample(shape)
	.subscribe { print($0) }
    color.onNext("Red")
    color.onNext("Star")
}
```


## switchLatest

Observable들을 하나의 Observable로 변경시켜준다. 단, 가장 최근의 아이템들이 방출된다.<br/>

<img width="640" alt="switch c" src="https://user-images.githubusercontent.com/70322435/221342097-4c2fa637-d5a4-415a-b15a-585fad4c7aab.png">

![switchLatest_xcode](https://user-images.githubusercontent.com/70322435/221342099-0c3f3b9e-bd4d-4cad-bd0b-6ada4c7a529e.jpg)


## reduce

Observable의 각 아이템에 순차적으로 특정 function을 적용하고 최종값을 방출한다.<br/>
scan과는 다르게 최종값만 방출한다<br/>

![reduce](https://user-images.githubusercontent.com/70322435/221342257-abaa74e3-3287-4ee0-aa79-07d1d2a68569.jpg)

![reduce_xcode](https://user-images.githubusercontent.com/70322435/221342258-8487475e-18c6-4933-8103-cfd3c9889249.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observation
	.reduce(0, accumulator: +)
	.subscribe { print($0) }
	.dispose()
}
```

0을 시작으로 1, 2, 3, 4, 5를 순차적으로 더한 최종값이 방출되기 때문에 결과적으로, <br/>
15<br/>
completed<br/>
가 출력된다.<br/>

