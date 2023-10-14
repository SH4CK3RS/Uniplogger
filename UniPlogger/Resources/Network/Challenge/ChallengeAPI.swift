//
//  ChallengeAPI.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/29.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

import Moya
import RxSwift

struct ChallengeAPI {
    
    let disposeBag = DisposeBag()
    
    static let shared = ChallengeAPI()
    
    private let provider = MoyaProvider<ChallengeAPITarget> (
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func startChallenge(completion: @escaping (Result<BaseResponse<Bool>, Error>) -> Void) {
        provider.rx.request(.startChallenge)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<Bool>.self)
            .subscribe(onSuccess: {
                completion(.success($0))
            }, onFailure: { completion(.failure($0)) })
            .disposed(by: disposeBag)

    }
    
    func fetchPlanet(completionHandler: @escaping (Result<BaseResponse<Planet?>, Error>)-> Void) {
        provider.rx.request(.fetchPlanet)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<Planet?>.self)
            .subscribe(onSuccess: {
                completionHandler(.success($0))
            }, onFailure: { completionHandler(.failure($0)) })
            .disposed(by: disposeBag)
    }
    
    func report(id: Int, completion: @escaping (Result<BaseResponse<Feed>, Error>) -> Void) {
        provider.rx.request(.report(id: id))
//            .filterSuccessfulStatusCodes()
            .map(BaseResponse<Feed>.self)
            .subscribe(onSuccess: {
                print("success")
                completion(.success($0))
            }, onFailure: {
                print("error")
                completion(.failure($0))
            })
            .disposed(by: disposeBag)
    }
    
}
