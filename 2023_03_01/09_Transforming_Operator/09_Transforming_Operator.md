# Transforming Operator

## toArray

Observable을 다른 object 또는 데이터 구조로 변형하는 역할을 한다.<br/>
특히 toArray는 Observable의 여러 이벤트를 받아 배열로 묶어주는 역할을 한다.<br/>

<img width="640" alt="01_to c" src="https://user-images.githubusercontent.com/70322435/219934639-7db14635-7415-4c5c-a546-6aaea1f77158.png">

![01_toArray_xcode](https://user-images.githubusercontent.com/70322435/219934641-551ee55c-6ae1-47ec-bd3a-63b1669ae85a.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observation
	.toArray()
	.subscribe { string in
	    print(string)
	}
	.dispose()
}
```

위 코드의 결과값은<br/>
success([1, 2, 3, 4, 5])<br/>
가 된다.<br/>

## map

map은 Observable의 각각의 아이템에 특정 함수를 적용시켜서 이벤트로 방출하는 역할을 한다.<br/>
다른 타입의 값으로 변경이 가능하다.<br/>

![02_map](https://user-images.githubusercontent.com/70322435/219934764-64efda3a-9041-4e61-a646-9215debe19d1.jpg)

![02_map_xcode](https://user-images.githubusercontent.com/70322435/219934765-764602fc-aef4-4820-864c-c52210f2f6c5.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observation
        .map({ number in
	    number * 10
	})
        .subscribe { string in
            print(string)
        }
        .dispose()
}
```

위 코드에서 map을 활용해 각각의 이벤트에서 방출되는 값에 10을 곱해서 방출하게 한다.<br/>
결과값은<br/>
10<br/>
20<br/>
30<br/>
40<br/>
50<br/>
completed<br/>
가 된다.<br/>

## compactMap

map과 마찬가지로 Observable의 각각의 이벤트를 옵셔널로 바꾼 뒤 변환한다.<br/>
만약 변환된 값이 nil이라면 nil은 방출하지 않는다.<br/>

![03_compactMap_xcode](https://user-images.githubusercontent.com/70322435/219935366-733b1d09-5d6a-40fa-a6df-ed35ef6c98a2.jpg)


```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, nil, 4, 5)

    observation
        .compactMap({ number in
            number * 10
        })
        .subscribe { string in
            print(string)
        }
        .dispose()
}
```

위 코드에서 compactMap을 활용해 각각의 이벤트에서 방출되는 값중 nil을 방출하지 않는다.<br/>
결과값은<br/>
1<br/>
2<br/>
3<br/>
4<br/>
5<br/>
completed<br/>
가 된다.<br/>

## flatMap

Observable에 방출된 이벤트를 Observable로 변환한 다음, 그 방출들을 단일 Observable로 평면화한다.<br/>
즉, map을 적용한 Observable들을 모두 합쳐 하나의 Observable로 만들어준다.

<img width="640" alt="04_flatMap c" src="https://user-images.githubusercontent.com/70322435/219936789-2160873c-54cd-4dc6-af95-0d77017a7abf.png">

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.of(1, 2, 3)
    let observationTwo = Observable.of("A", "B", "C")

    observationOne
	.flatMap({ number -> Observable<String> in
	    print(number)
	    return observationTwo
	})
	.subscribe(onNext: { string in
	    print(string)
	})
	.dispose()
}
```


## flatMapFirst

flatMap은 새롭게 생성한 Observable도 함께 방출한다.<br/>
하지만, flaMapFirst는 이전에 생성한 Observable의 이벤트가 다 끝나기 전까지 새롭게 생성한 Observable은 무시한다.

![flatMapFirst_xcode](https://user-images.githubusercontent.com/70322435/220550325-f7f8c99c-939e-4e6e-a853-84ec1e629695.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.of(1, 2, 3)
    let observationTwo = Observable.of("A", "B", "C")

    observationOne
        .flatMapFirst({ number -> Observable<String> in
            print(number)
            return observationTwo
        })
        .subscribe(onNext: { string in
            print(string)
        })
        .dispose()
}
```

위 코드를 실행하면 observationOne의 1과 observationTwo의 이벤트를 방출하고 끝이난다.<br/>
observationOne에서 이벤트 1을 방출하고 다음 이벤트인 2와 3을 방출해야 하지만 무시되기 때문이다.<br/>

## flatMapLatest

flatMapLatest는 Observable이 이벤트를 방출하는 동안 다음 이벤트가 발생하면 기존 Observable을 dispose시키고 다음 이벤트의 Observable을 실행한다.<br/>

![flatMapLatest](https://user-images.githubusercontent.com/70322435/220550431-092d21c1-d251-4471-a7b4-f93fb3303db5.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.of(1, 2, 3)
    let observationTwo = Observable.of("A", "B", "C")

    observationOne
        .flatMapLatest({ number -> Observable<String> in
            print(number)
            return observationTwo
        })
        .subscribe(onNext: { string in
            print(string)
        })
        .dispose()
}
```

위 코드는 observationOne의 1 이벤트가 방출되고 observationTwo의 A 이벤트가 방출된다.<br/>
그런데 observationTwo의 B 이벤트가 방출되기 전, observationOne의 2 이벤트가 방출되기 때문에 observationTwo는 dispose된다.<br/>
따라서 결과적으로 <br/>
1<br/>
A<br/>
2<br/>
A<br/>
3<br/>
A<br/>
B<br/>
C<br/>
가 출력된다.<br/>

## concatMap



## scan



## buffer



## window



## groupBy
