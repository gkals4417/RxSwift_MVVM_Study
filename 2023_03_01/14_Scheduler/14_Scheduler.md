# Scheduler

Scheduler는 작업을 어디서 수행할지 결정할 수 있게 해준다.<br/>
Swift의 DispatchQuee처럼 Main Thread에서 할지 등을 정할 수 있다.<br/>
Observable을 생성하는 작업을 어디서 할 지 졀정할 수 있다.<br/>

<img width="640" alt="schedulers" src="https://user-images.githubusercontent.com/70322435/221872556-eed63823-6e12-4a87-91e2-a819dc6d8890.png">

## observeOn

observeOn은 Observable을 어떤 쓰레드에서 관찰할지 설정할 수 있다.<br/>

![observeOn_xcode](https://user-images.githubusercontent.com/70322435/221873288-fdf4cfeb-83e3-4559-a50a-02cdacc3bdfd.jpg)

## subscribeOn

Observable이 어디서 일어나게 할 것인지 결정할 수 있다.<br/>

![subscribeOn_xcode](https://user-images.githubusercontent.com/70322435/221873295-d0c74272-b775-4b06-af28-397007bb7a79.jpg)

## Scheduler의 종류

###  MainScheduler

메인 쓰레드에서 작업을 수행한다.<br/>
UI를 갱신하기 위해서는 MainScheduler를 사용해야 한다.<br/>

### SerialDispatchQueueScheduler

background에서 작업할 때 사용한다.<br/>

### ConcurrentDispatchQueueScheduler

SerialDispatchQueueScheduler와 비슷하다. 하지만, 병렬로 일을 처리한다.<br/>

### TestScheduler

테스트를 위한 Scheduler이다. <br/>

