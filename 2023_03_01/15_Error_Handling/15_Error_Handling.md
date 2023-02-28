# Error Handling

## catch

만약 Observable의 이벤트가 에러가 발생했을 경우, onError로 종료되는 것이 아니라, 새로운 이벤트를 발생하고 onCompleted 될 수 있도록 해준다.<br/>

<img width="640" alt="Catch" src="https://user-images.githubusercontent.com/70322435/221881586-b08cdf9b-89df-4168-9cec-61fd88a3fcc9.png">

![catch_xcode](https://user-images.githubusercontent.com/70322435/221881714-2fa66fbd-a41f-4ecf-8724-68d611247ad8.jpg)

## catchAndReturn

catch와 비슷하게 이벤트가 에러가 발생했을 경우, 특정 값을 onNext 이벤트로 전달한다.<br/>
새로운 Observable을 리턴하는 catch와의 다른점이다.<br/>

![catchAndReturn_xcode](https://user-images.githubusercontent.com/70322435/221882764-e0dc85bc-139c-4fb1-b900-a9501f0e78f5.jpg)

## retry

만약 Observable의 이벤트가 에러를 방출할 경우, 에러가 발생하지 않을때까지 다시 subscribe를 반복한다.<br/>
여기서 최대 시도 횟수를 정할 수 있는데, 여기서 이 횟수는 처음 시도 횟수도 포함되니 유의해야 한다.<br/>

<img width="640" alt="retry C" src="https://user-images.githubusercontent.com/70322435/221883891-9768be00-cc8a-4914-ba4a-0199c6c617e1.png">

![retry_xcode](https://user-images.githubusercontent.com/70322435/221883904-f5259d38-ab17-4e13-b725-e9a844ab24b8.jpg)

## retryWhen

retry는 에러가 방출되면 무한정으로 retry하지만, 특정 시점에서 retry를 하기 위해 retryWhen을 사용한다.<br/>

![retryWhen_xcode](https://user-images.githubusercontent.com/70322435/221885792-ba7ce810-5839-481a-ac6b-f4a3b5252aa3.jpg)

