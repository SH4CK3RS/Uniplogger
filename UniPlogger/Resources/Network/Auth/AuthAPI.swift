//
//  AuthAPI.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/24.
//  Copyright © 2020 손병근. All rights reserved.
//

import Moya
import RxSwift

struct AuthAPI {
    let disposeBag = DisposeBag()
    
    static let shared = AuthAPI()
    private let provider = MoyaProvider<AuthAPITarget>(
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func initQuest() {
        provider.rx.request(.initQuest)
            .filterSuccessfulStatusCodes()
            .subscribe().disposed(by: disposeBag)
    }
    
    func logout() {
        provider.rx.request(.logout)
            .filterSuccessfulStatusCodes()
            .subscribe { (data) in
                print(data)
            } onFailure: { (error) in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)

    }
    
    func withdraw(uid: Int) {
        provider.rx.request(.withdraw(uid: uid))
            .filterSuccessfulStatusCodes()
            .subscribe { (data) in
                print(data)
            } onFailure: { (error) in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func findPassword(email: String, completion: @escaping (Result<BaseResponse<FindPasswordResponse>, Error>) -> Void) {
        provider.rx.request(.findPassword(email: email))
            .filterSuccessfulStatusCodes()
            .map (BaseResponse<FindPasswordResponse>.self)
            .subscribe {
                completion(.success($0))
            } onFailure: {
                completion(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func resetPassword(password1: String, password2: String, uid:String, token: String, completion: @escaping (Result<BaseResponse<ResetPasswordResponse>, Error>) -> Void) {
        provider.rx.request(.resetPassword(password1: password1, password2: password2, uid: uid, token: token))
            .filterSuccessfulStatusCodes()
            .map (BaseResponse<ResetPasswordResponse>.self)
            .subscribe {
                completion(.success($0))
            } onFailure: {
                completion(.failure($0))
            }.disposed(by: disposeBag)
    }
 
    // MARK: - RxSwift
    func login(email: String, password: String) -> Single<LoginResponse> {
        provider.rx.request(.login(email: email, password: password))
            .map(BaseResponse<LoginResponse>.self)
            .flatMap { response -> Single<LoginResponse> in
                if let data = response.data {
                    return .just(data)
                } else {
                    return .error(UniPloggerError.networkError(.responseError(ErrorMessage.decodeError)))
                }
            }
    }
    
    func registration(data: RegistrationModel) -> Single<LoginResponse> {
        provider.rx.request(.registration(
            email: data.email,
            password1: data.password,
            password2: data.passwordConfirm,
            nickname: data.nickname
        ))
        .map(BaseResponse<LoginResponse>.self)
        .flatMap { response -> Single<LoginResponse> in
            if let data = response.data {
                return .just(data)
            } else {
                return .error(UniPloggerError.networkError(.responseError(ErrorMessage.decodeError)))
            }
        }
    }
}
