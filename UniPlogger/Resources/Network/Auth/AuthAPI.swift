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
        stubClosure: MoyaProvider.immediatelyStub,
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func login(email: String, password: String, completionHandler: @escaping (Result<BaseResponse<LoginResponse>, Error>) -> Void) {
        provider.rx.request(.login(email: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<LoginResponse>.self)
            .observe(on: MainScheduler.instance)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func getUser(uid: Int, completionHandler: @escaping (Result<BaseResponse<User>, Error>) -> Void) {
        provider.rx.request(.getUser(uid: uid))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<User>.self)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func registration(email: String, password1: String, password2: String, nickname: String, completion: @escaping (Result<BaseResponse<LoginResponse>, Error>) -> Void) {
        provider.rx.request(.registration(email: email, password1: password1, password2: password2, nickname: nickname))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<LoginResponse>.self)
            .subscribe {
                completion(.success($0))
            } onFailure: {
                completion(.failure($0))
            }.disposed(by: disposeBag)
    }
    
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
                    return .error(UniPloggerError.networkError(.responseError("")))
                }
            }
    }
}
