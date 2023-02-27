# Sharing Subscription

## multicast

다른 Observable이 해당 Observable을 subscribe할 때 필요한 operator이다.<br/>
단순히 multicast operator만 사용하면 안되고, connect라는 operator를 사용해야지만 그제서야 이벤트 방출이 시작된다.<br/>

<img width="640" alt="publishConnect c" src="https://user-images.githubusercontent.com/70322435/221494460-a7cf89f3-29ff-4dc8-ac33-8c5a55d11504.png">

![multicast_xcode](https://user-images.githubusercontent.com/70322435/221494464-0505d641-6df5-4fbc-9abb-ba7f32d94d68.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = PublishSubject<Int>()

    let mainObservation = Observable<Int>
	.interval(.seconds(1), scheduler: MainScheduler.instance)
	.multicast(observation)

    mainObservation
	.subscribe { print($) }

    mainObservation
	.delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
	.subscribe { print($0) }

    mainObservation
	.connect()
}
```

## publish

multicast operator를 조금 더 간단하게 구현하게 해주는 operator이다.<br/>

![publish_xcode](https://user-images.githubusercontent.com/70322435/221495769-1c9d6bf0-fa44-4b45-982b-ed680b424429.jpg)


## replay

만약 Observable이 이벤트를 방출하기 시작한 이후에 subscribe를 하더라도 이전 이벤트를 모두 받을 수 있게 해준다.<br/>

<img width="640" alt="replay c" src="https://user-images.githubusercontent.com/70322435/221496625-73314eb9-d0fd-437c-98bc-4e7455712e42.png">

![replay_xcode](https://user-images.githubusercontent.com/70322435/221496434-149c9222-d932-4259-b241-cba129e128bf.jpg)


## refCount

내부에 ConnectableObservable을 유지하면서 새로운 subscribe가 추가되는 시점에 자동으로 connect 메서드를 호출한다.<br/>

<img width="640" alt="publishRefCount c" src="https://user-images.githubusercontent.com/70322435/221497041-8441fc31-764b-4541-a7b8-1b357abebd18.png">

![refCount_xcode](https://user-images.githubusercontent.com/70322435/221497045-af4fbc94-9202-4732-82fc-ba4429d07894.jpg)


## share

간단하게 공유하는 Observable을 만들 수 있는 operator이다.<br/>

![share_xcode](https://user-images.githubusercontent.com/70322435/221497898-1dcb6497-0426-407f-9f48-f8f7d2951edf.jpg)

