//
//  APIManagerType.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//

import Foundation
import RxSwift

protocol APIManagerTypeRx {
    
    func fetchCurrentData(city: String, apiType: String) -> Observable<CurrentWelcome>
    func fetchForeCastData(city: String, apiType: String) -> Observable<[ForeCastList]>
//    func kakaoLogin(loginRequest: UserOAuthLoginRequest, onSuccess:@escaping(UserLoginResponse) -> Void, onFailure:@escaping(String) -> Void)
//    func updateNickName(nickName: NickNameDto, onSuccess:@escaping() -> Void, onFailure:@escaping(String) -> Void)
}
