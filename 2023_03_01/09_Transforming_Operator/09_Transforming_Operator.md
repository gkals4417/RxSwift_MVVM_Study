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

flatMap과 비슷한 역할을 해주지만, concatMap은 순서를 보장해준다.<br/>

![concatMap](https://user-images.githubusercontent.com/70322435/220635242-a7e5528b-c9d4-4d51-8b7e-0de3aa2ee467.png)

![concatMap_xcode](https://user-images.githubusercontent.com/70322435/220635261-40d27867-5d00-4d0a-8de9-499b803a7d3b.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.of(1, 2, 3)
    let observationTwo = Observable.of("A", "B", "C")

    observationOne
        .concatMap({ number -> Observable<String> in
            print(number)
            return observationTwo
        })
        .subscribe(onNext: { string in
            print(string)
        })
        .dispose()
}
```

concatMap을 통해 observationOne과 observationTwo가 합쳐져서 이벤트가 방출된다.<br/>

## scan

scan은 Observer에서 방출된 아이템들을 다음 이벤트와 계속 연산하는 operator이다.<br/>

![scan](https://user-images.githubusercontent.com/70322435/220637363-bd76b8fa-e978-4d72-a889-218a77053500.jpg)

![scan_xcode](https://user-images.githubusercontent.com/70322435/220637371-90eaa0a1-04b9-4241-bf89-c0ec28aa9102.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observation
	.scan(0, accumulator: +)
	.subscribe { int in
	    print(int)
	}
	.dispose()
}
```

위 코드는 0부터 시작해서 observation에 있는 각각의 이벤트를 더하면서 방출해준다.<br/>
즉, 0<br/>
0 + 1 = 1<br/>
1 + 2 = 3<br/>
3 + 3 = 6<br/>
6 + 4 = 10<br/>
10 + 5 = 15<br/>
로 값이 출력된다. <br/>


## buffer

buffer는 주기적으로 방출되는 이벤트들을 배열로 묶어준다음, 그 배열을 이벤트로 방출한다.<br/>
파라미터는 timeSpan, count, scheduler가 있는데, 각각 어느 정도의 시간 간격으로 이벤트 배열을 방출되는지 결정하고, 최대 몇개의 요소를 담을건지 결정하고, 마지막으로 연산자가 실행될 쓰레드를 결정해준다.<br/>

<img width="640" alt="Buffer" src="https://user-images.githubusercontent.com/70322435/220639943-89a28bfe-a82b-4fac-aff5-6ec876ef932f.png">

![buffer_xcode](https://user-images.githubusercontent.com/70322435/220639986-f827e208-1480-40b2-9d9d-99fda867de95.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observationOne
	.buffer(timeSpan: .seconds(2), count: 2, scheduler: MainScheduler.asyncInstance)
	.subscribe { int in
	    print(int)
	}
	.dispose()
}
```

1, 2, 3, 4, 5 다섯개의 이벤트를 2개씩 묶기 때문에 결과적으로 <br/>
[1, 2]<br/>
[3, 4]<br/>
[5]<br/>
가 된다.<br/>


## window

buffer와 매우 비슷하지만, buffer는 배열을 방출하는 반면, window는 각각의 이벤트들을 방출한다.<br/>

<img width="640" alt="window C" src="https://user-images.githubusercontent.com/70322435/220642468-3cfd1fec-aa8a-40a9-8d0b-220894843cd3.png">

![window_xcode](https://user-images.githubusercontent.com/70322435/220642475-160b1281-d0bf-4967-ab20-81478445067d.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observation
	.window(timeSpan: .second(3), count: 2, scheduler: MainScheduler.instance)
	.subscribe { event in
	    switch evert {
	    case .next (let observable):
		observable.subscribe { int in
		    print(int)
		}
	    default:
		print("Finished")
	    }}
	}
	.dispose()
}
```

위 코드의 결과값은<br/>
1<br/>
2<br/>
completed<br/>
3<br/>
4<br/>
completed<br/>
5<br/>
completed<br/>
Finished<br/>
가 된다.<br/>

## groupBy

groupBy는 Observable의 각각 이벤트들을 분류해서 Observable로 만들어 방출하는 operator이다.<br/>

<img width="640" alt="groupBy c" src="https://user-images.githubusercontent.com/70322435/220646549-7c491530-9553-44dc-94cd-b8f4f29fc319.png">

![groupby_xcode](https://user-images.githubusercontent.com/70322435/220646557-a44c23c8-db32-4ac8-b48a-56c2a512eaa7.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.of(1, 2, 3, 4, 5)

    observation
	.groupBy(keySelector: { i -> String in
	    if i % 2 == 0 {
		return "짝수"
	    } else {
		return "홀수"
	    }
	})
	.flatMap { number -> Observable<String> in
	    if number.key == "짝수" {
		return number.map { v in
		    "짝수 \(v)"
		}
	    } else {
		return number.map { v in
		    "홀수 \(v)"
		}
	    }
	}
	.subscribe(onNext: { string in
	    print(string)
	})
	.dispose()
    }v  
}
```

위 코드는 숫자가 2로 나눠질 경우와 나눠지지 않을 경우, 각각 key값을 "짝수"와 "홀수"로 정하고, flatMap을 통해 이벤트를 어떻게 출력할지 정해줬다. <br/>
마지막으로 subscribe를 통해 출력이 되는데, 그 결과로는<br/>
홀수 1<br/>
짝수 2<br/>
홀수 3<br/>
짝수 4<br/>
홀수 5<br/>
가 된다.<br/>

