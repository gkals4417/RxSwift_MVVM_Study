# RxSwift?

![RxSwift_Logo](https://user-images.githubusercontent.com/70322435/219868618-b4acb8d4-028f-4cfa-96e2-d59c37dee4ee.png)

RxSwift가 뭐지? 어디서 많이 본 것 같은데...<br/>
Rx는 Reactive eXtensions의 약자로 관찰 가능한 시퀀스를 사용해서 비동기 및 이벤트 기반 프로그램을 구성하기 위한 라이브러리이다.<br/>
특히 MVVM 패턴을 사용할 때 View와 ViewModel을 바인딩을 해줘야 한다. 이 때 RxSwift를 이용하면 쉽게 바인딩을 할 수 있게 된다.<br/>

그럼 RxSwift를 쓰는 이유는 무엇일까?<br/>

1. RxSwift를 사용하면 가독성이 좋아진다.
2. 비동기 처리를 모두 Observable 타입을 이용해서 처리할 수 있다.

Swift에서는 비동기 처리를 위해 Notification Center, Delegate 패턴, GCD, 클로저를 제공한다.<br/>
하지만 RxSwift를 사용하면 더 간단하고 편리하게 비동기 처리를 할 수 있다.<br/>
<br/>
중요한 것은 **반응형**과 **관찰 가능하다**는 것이다.
