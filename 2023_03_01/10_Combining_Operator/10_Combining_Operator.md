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
(Blue", "Star")<br/>
가 된다.<br/>

## zip

## withLatestFrom

## sample

## switchLatest

## reduce

