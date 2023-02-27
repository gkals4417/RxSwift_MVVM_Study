# Time-Based Operator

## interval

특정 시간 간격동안 Obsavable의 이벤트들을 방출하는 operator이다.<br/>

<img width="640" alt="interval c" src="https://user-images.githubusercontent.com/70322435/221484886-59c68c94-97df-4f1e-8ca2-83ba2d625f5d.png">

![interval_xcode](https://user-images.githubusercontent.com/70322435/221484894-fb33a8ac-dd17-4db1-8709-3b6fd548ff89.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)

    observation
    .subscribe { print($0) }
}
```

위 코드는 버튼을 클릭하면 1초를 간격으로 숫자를 하나씩 출력하는 코드이다. <br/>
딱히 종료를 위한 코드를 넣지 않았기 때문에 프로그램을 강제로 종료하지 않는 이상 계속 숫자가 출력될 것이다.<br/>


## timer

timer는 inerval과 다르게 특정 시간이 지난 후에 Observable의 이벤트를 방출하게 해준다.<br/>

<img width="640" alt="timer c" src="https://user-images.githubusercontent.com/70322435/221485496-1dc59c4f-403a-4bad-8d68-37780aaf3807.png">

![timer_xcode](https://user-images.githubusercontent.com/70322435/221485502-27065dad-1f13-4c14-9f5b-e3a4dc5a56ac.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observation = Observable<Int>
        .timer(.seconds(3), period: .second(1), scheduler: MainScheduler.instance)

    observation
        .subscribe { print($0) }
}
```

위의 코드는 3초 뒤에 Observable의 이벤트가 방출되기 시작하며 1초를 간격으로 이벤트가 방출된다.<br/>
즉, 3초 뒤부터 1초 간격으로<br/>
1<br/>
1<br/>
...<br/>
이렇게 출력된다.<br/>


## timeout

특정 시간이 지나면 error를 내보내주는 operator이다.<br/>

<img width="640" alt="timeout c" src="https://user-images.githubusercontent.com/70322435/221488591-3f2d57af-d924-4ac3-a766-20be0b8e8bab.png">

![timeout_xcode](https://user-images.githubusercontent.com/70322435/221488597-53a1d13b-4c3d-4e4f-b1f6-b3e48f6a9ec6.jpg)


## delay

Observable의 이벤트 방출을 특정 시간만큼 늦출 수 있는 operator이다.<br/>

![delay](https://user-images.githubusercontent.com/70322435/221489147-262f6feb-d641-40f8-8f7d-82d236eb3ddf.jpg)

![delay_xcode](https://user-images.githubusercontent.com/70322435/221489154-ed477772-0739-4408-85e9-0531612e6966.jpg)

```swift
@IBAction func tapped(_ sender: UIButton) {
    let observtion = Observable<Int>
    .interval(.seconds(1), scheduler: MainScheduler.instance)

    observation
    .delay(.seconds(2), scheduler: MainScheduler.instance)
    .subscribe { print($0) }
}
```

위 코드는 delay operator 때문에 2초 뒤에 interval operator가 작동되고, interval operator 때문에 1초마다 이벤트를 방출한다.<br/>


## delaySubscribtion

subscribe하는 시점을 지연시킨다.<br/>

![delaySubscription_xcode](https://user-images.githubusercontent.com/70322435/221489810-2917827c-77af-40d3-af42-f618df2ab9e7.jpg)

