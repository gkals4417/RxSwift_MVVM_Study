# Subscribe

사전적 의미 : 구독하다, 가입하다, 시청하다<br/>
<br/>
Observable의 **방출**과 notification에 의해 작동하는 **operator**<br/>
<br/>
> Operator에 대해서는 다음에 더 자세하게 설명할 예정이다.<br/>
<br/>
Subscribe는 Observable과 observer을 연결해주는 역할을 한다.<br/>
Observable에서 방출되는 항목들이나 error, completed와 같은 notification을 듣기 위해서는 Observable을 **구독**해야 하는데 이때 사용하는 operator가 바로 **subscribe**이다.<br/>

![Observable_subscribe](https://user-images.githubusercontent.com/70322435/219848599-b25fef29-4067-4d14-a010-0cac676be27f.jpg)


## Example

```swift
@IBAction func tapped(_ sender: UIButton) {
    _ = obseerveFunc()
	.subscribe { event in
	    switch event {
	    case .next(let myString):
		print(myString!)
	    case .error:
		break
	    case .completed:
		break
	    }
	}
}
```

스토리보드로 버튼을 만들고, 버튼을 누를 때마다 이전 포스트에서 구현했던 observeFunc()를 subscribe하여 onNext의 "Hello"를 프린트한다.
