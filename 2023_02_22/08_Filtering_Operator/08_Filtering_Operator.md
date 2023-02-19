# Filtering Operator

말 그대로 필터링과 관련되어있는 operator이다.<br/>

## IgnoreElements

IgnoreElements는 Observable의 모든 next 이벤트를 방출하지 않는다.<br/>
다만, completed나 error와 같은 notification은 알려준다.<br/>
completed나 error에 대한 알림반 받고 싶은 경우, IgnoreElements를 사용하면 된다.<br/>

<img width="640" alt="ignoreElements c" src="https://user-images.githubusercontent.com/70322435/219908287-e3fda96e-ab94-4590-97c3-c795c7aeb9c4.png">
![ignoreElement_xcode](https://user-images.githubusercontent.com/70322435/219908289-f674ccf7-4286-4bd7-80a9-3f4b652ab59d.jpg)

```swift
let observation: Observable<String?> = Observable.just("Hello")

@IBAction func tapped(_ sender: UIButton) {
    _ = observation
	.ignoreElements()
	.subscribe(onNext: { string in
	    print(string)
	}, onError: { error in
	    print(error)
	}, onCompleted: {
	    print("completed")
	}, onDisposed: {
	    print("disposed")
	})
	.dispose()
}
```

버튼을 누르면<br/>
completed<br/>
disposed<br/>
를 출력한다. <br/>
IgnoreElements는 next에 대한 이벤트는 방출하지 않기 때문에 Observable의 just operator의 "Hello"는 방출하지 않는 것을 볼 수 있다.<br/>

## ElementAt

ElementAt은 Observable의 이벤트 중 index에 해당하는 이벤트만 방출한다.<br/>

![elementAt](https://user-images.githubusercontent.com/70322435/219908317-674dc2b8-31fa-4161-b15d-5ef431d3cdca.jpg)
![elementAt_xcode](https://user-images.githubusercontent.com/70322435/219908318-ee9283bf-fea4-49bb-b46e-0c67310fb969.jpg)


```swift
let observation = Observable.range(start: 1, count: 5)

@IBAction func tapped(_ sender: UIButton) {
    _ = observation
        .elementAt(2)
        .subscribe(onNext: { string in
            print(string)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("completed")
        }, onDisposed: {
            print("disposed")
        })
        .dispose()
}
```

원래라면 1, 2, 3, 4, 5가 순서대로 출력되야 하지만, elementAt(2) 때문에 index값 2에 해당하는 3이 출력된다.<br/>
그리고 completed와 disposed를 방출하고 종료된다.<br/>

.elementAt(_ index:) 대신 .element(at: )을 사용한다.<br/>

## Filter

테스트를 통과한 이벤트만 방출하게 하는 operator이다.<br/>
조건을 설정하고, 설정된 조건에 맞는 이벤트만 순서대로 방출된 뒤 completed로 종료된다.<br/>

![filter](https://user-images.githubusercontent.com/70322435/219908358-e5d4cfb2-6814-414d-87d4-8df5e570f260.jpg)
![filter_xcode](https://user-images.githubusercontent.com/70322435/219908360-00b9f536-69c4-4552-be19-8dcc75e0c77b.jpg)


```swift
let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.from(array)
    observation.filter { number in
	number > 5
    }
    .subscribe { int in
	print(int)
    }
    .dispose()
}
```

array라는 배열 안에 1부터 10까지 정수가 들어있다.<br/>
from이라는 operator를 사용하면 각각의 요소들이 하나하나 이벤트로 나오게 되는데, 여기서 filter operator를 통해 5보다 큰 정수들만 방출하는 조건을 만들었다.<br/>
그렇기 때문에 버튼을 누르면 결과는<br/>
6<br/>
7<br/>
8<br/>
9<br/>
10<br/>
completed<br/>
가 출력된다.<br/>

## Skip

Observable에서 방출된 이벤트들 중에서 앞의 n번째 이벤트까지 무시하고 그 다음 이벤트를 방출한다.<br/>

![skip](https://user-images.githubusercontent.com/70322435/219908369-1b2fda77-d343-4875-8c90-df07ba867b5c.jpg)
![skip_xcode](https://user-images.githubusercontent.com/70322435/219908372-abb40e9e-a47f-4091-8c3c-77c04b244de1.jpg)

```swift
let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.from(array)
    observation.skip(8)
    .subscribe { int in
	print(int)
    }
    .dispose()
}
```

위 코드에서 8번째 요소까지 무시하고 남은 이벤트인 9와 10을 방출한다.<br/>
따라서 결과적으로<br/>
9<br/>
10<br/>
completed<br/>
가 출력된다.<br/>


## skip(while:)

skip(while:)은 검사를 통과하지 못한 요소들을 방출한다. filter와 비슷하면서도 반대라고 생각하면 된다.<br/>

<img width="640" alt="skipWhile c" src="https://user-images.githubusercontent.com/70322435/219908588-9f99f66f-b452-47e1-88b6-745f25d4cb7a.png">
![skipwhile_xcode](https://user-images.githubusercontent.com/70322435/219908403-a40f96f8-8e72-4c1a-a6f4-85214e652a2d.jpg)

```swift
let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.from(array)
    observation.skip(while: { number in
	number < 5
    })
    .subscribe(onNext: { int in
	print(int)
    })
    .dispose()
}
```

위 코드는, 1부터 10까지 들어있는 배열의 요소들을 하나씩 추출해서 이벤트로 방출을 하는데, skip(while:)에 의해 걸러지게 된다.<br/>
요소의 크기가 5보다 작으면 (true) 방출하지 않고, 5 이상인 경우(false) 방출을 하게 된다.<br/>
결과적으로 <br/>
5<br/>
6<br/>
7<br/>
8<br/>
9<br/>
10<br/>
이 된다.<br/>


## skip(until:)

두 개의 Observable이 있다면, 두번째 Observable이 이벤트를 방출하기 전까지 첫번째 Observable의 이벤트는 방출되지 않는다.<br/>

![skipUntil](https://user-images.githubusercontent.com/70322435/219908410-f3cdf8f8-59fa-4602-8838-40af1e3cb2b4.jpg)
![skipUntil_xcode](https://user-images.githubusercontent.com/70322435/219908416-e21091a8-6c1e-4ca7-aae1-7c2cdeeb6264.jpg)

```swift
let array = [1, 2, 3, 4, 5]
let array2 = [11, 12, 13, 14, 15]

@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.from(array)
    let observationTwo = Observable.from(array2)

    observationOne.skip(until: observationTwo)
    .subscribe { int in
	print(int)
    }
    .dispose()

    observationTwo.subscribe { int in
	print(int)
    }
    .dispose()
}
```

위 코드는, array와 array2 배열 두개가 있고 각각 observationOne, observationTwo로 Observable을 만들었다.<br/>
그리고 observationOne을 구독했는데 이때, observationTwo를 두번째 Observable로 설정했다.<br/>
버튼을 누르면 처음에는 observationTwo가 이벤트를 방출하지 않기 때문에 observationOne에 있는 1은 방출하지 않는다.<br/>
이후 observationTwo가 이벤트를 방출하기 때문에 observationOne의 나머지 요소들도 방출되기 시작한다.<br/>
결과적으로<br/>
2<br/>
3<br/>
4<br/>
5<br/>
completed<br/>
11<br/>
12<br/>
13<br/>
14<br/>
15<br/>
completed<br/>
가 나오게 된다.<br/>


## skip(duration:)

skip(duration:)은 시간을 지정해서 Observable이 방출하는 이벤트를 무시할 수 있다.<br/>

![skipDuration_xcode](https://user-images.githubusercontent.com/70322435/219908423-05cd41f4-e145-4461-ae54-e3fa5fbb522c.jpg)

## take

skip과 반대로, Observable의 n번째 이벤트까지 방출을 하고 나머지 이벤트는 무시하고 바로 complete한다.<br/>

![take](https://user-images.githubusercontent.com/70322435/219908445-48ad29c6-7ff9-43e8-9a30-01938f6e36e4.jpg)
![take_xcode](https://user-images.githubusercontent.com/70322435/219908450-2a278673-fe4d-4639-bcaf-a43fe5aa4f17.jpg)

```swift
let array = [1, 2, 3, 4, 5]

@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.from(array)

    observation
	.take(3)
	.subscribe { int in
	    print(int)
	}
	.dispose()
}
```

위의 코드에서 from operator때문에 Observable은 총 5개의 이벤트를 방출해야 한다.<br/>
하지만, take(3)으로 인해 총 3개의 이벤트를 방출하게 된다.<br/>
결과적으로<br/>
1<br/>
2<br/>
3<br/>
completed<br/>
가 방출되다.<br/>

## take(while:)

Observable의 아이탬을 똑같이 방출한다. 하지만, 특정 조건이 참이 되면 더이상 방출하지 않고 complete된다.<br/>

![takewhile_xcode](https://user-images.githubusercontent.com/70322435/219908460-e6d6cd2b-7551-43ee-b51b-0ed833c17d70.jpg)
<img width="640" alt="takeWhile c" src="https://user-images.githubusercontent.com/70322435/219908549-457aa29f-d046-4225-a5a2-ff6d610a4177.png">

```swift
let array = [1, 2, 3, 4, 5]

@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.from(array)

    observation
        .take(while: { number in
	    number < 3
	})
        .subscribe { int in
            print(int)
        }
        .dispose()
}
```

동일하게 from으로 인해 배열의 각 요소들이 이벤트로 방출이 되는데, takeWhile에서 이벤트가 3보다 작을 때까지만 방출이 된다.<br/>
결국 결과적으로<br/>
1<br/>
2<br/>
completed<br/>
이 출력된다.<br/>

## take(until:)

두 개의 Observable이 있을 때, 만약 두번째 Observable이 방출되거나 종료된다면 그 즉시 첫번째 Observable의 방출도 멈추고 complete된다.<br/>
정리하면, 첫번째 Observable을 그대로 복사하는데, 두번째 Observable의 이벤트가 생기면 그 즉시 복사가 중지되는 것이다고 생각하면 된다.<br/>

![takeUntil](https://user-images.githubusercontent.com/70322435/219908472-aa67a072-4254-4e18-a556-473e7d45e08e.jpg)
![takeUntil_xcode](https://user-images.githubusercontent.com/70322435/219908474-edd9432b-6506-4e2e-9181-39713831d1ba.jpg)

## take(last:)

Observable의 이벤트 중, 마지막으로부터 n번째 이벤트까지만 방출하고 complete된다.<br/>
중요한 점은 Observable이 complete되야지만 방출이 된다는 점이다.<br/>

![takeLast](https://user-images.githubusercontent.com/70322435/219908485-5a9108de-5e74-49e3-9fdd-a7f59f07a46d.jpg)
![takeLast_xcode](https://user-images.githubusercontent.com/70322435/219908489-c0f89427-8cc3-454a-a4c0-e8201d67ef43.jpg)

```swift
let array = [1, 2, 3, 4, 5]

@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable.from(array)

    observation
	.takeLast(3)
	.subscribe { int in
	    print(int)
	}
	.dispose()
}
```

결과적으로 총 5개의 이벤트 중, takeLast(3)에 해당하는 3, 4, 5만 방출된다. <br/>

## take(for:)

take(for:)는 특정 시간만큼 이벤트를 방출하고, 시간이 끝나면 더이상 이벤트를 방출하지 않고 complete한다.<br/>

![takeFor_xcode](https://user-images.githubusercontent.com/70322435/219908501-762b0056-5bee-4d38-b9a7-e7a74a0b291f.jpg)

## single

First와 비슷한 operator이다.<br/>
First는 Observable의 첫번째 이벤트만 방출하고 complete하지만, single은 이벤트가 하나만 있을 경우 complete하고, 이벤트가 여러개일 경우 첫버째만 방출한 뒤 에러를 내보낸다.<br/>

![single_xcode](https://user-images.githubusercontent.com/70322435/219908520-f934b1b4-595b-4e03-8abf-586faf5fcfcf.jpg)

```swift
let array = [1, 2, 3, 4, 5]

@IBAction func tapped(_ sender: UIButton) {
    let observationOne = Observable.just(1)
    let observationTwo = Observable.from(array)

    observationOne
	.single()
	.subscribe { int in
	    print(int)
	}
	.dispose

    observationTwo
	.single()
	.subscribe { int in
	    print(int)
	}
	.dispose()
}
```

observationOne은 이벤트가 1 하나이지만, observationTwo는 이벤트가 1, 2, 3, 4, 5 총 다섯개이다.<br/>
그렇기 때문에 observationOne은<br/>
1<br/>
completed<br/>
이지만, observationTwo는<br/>
1<br/>
error(Sequence contains more than one element.)<br/>
로 에러가 나오게 된다.<br/>

## distinctUntilChanged


