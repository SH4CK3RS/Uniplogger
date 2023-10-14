//
//  LogAPI.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/28.
//  Copyright © 2020 손병근. All rights reserved.
//

import Moya
import RxSwift
import RxMoya

struct LogAPI {
    let disposeBag = DisposeBag()
    
    static let shared = LogAPI()
    private let provider = MoyaProvider<LogAPITarget> (
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func getFeed(uid: Int) -> Single<BaseResponse<[Feed]>> {
        provider.rx.request(.getFeed(uId: uid))
            .map(BaseResponse<[Feed]>.self)
    }
    
    func getFeed(uid: Int, completionHandler: @escaping (Result<BaseResponse<[Feed]>, Error>) -> Void) {
        provider.rx.request(.getFeed(uId: uid))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[Feed]>.self)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: self.disposeBag)
    }
    
    func getUserFeed(uid: Int, completionHandler: @escaping (Result<BaseResponse<[Feed]>, Error>) -> Void) {
        provider.rx.request(.getUserFeed(uid: uid))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[Feed]>.self)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: self.disposeBag)
    }
    
    func getOtherUser(uid: Int, completionHandler: @escaping (Result<BaseResponse<User>, Error>) -> Void) {
        provider.rx.request(.getOtherUser(uid: uid))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<User>.self)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func deleteFeed(fid: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        provider.rx.request(.deleteFeed(fid: fid))
            .filterSuccessfulStatusCodes()
            .subscribe { _ in
                completionHandler(.success(()))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func updateLevel(completionHandler: @escaping (Result<BaseResponse<User>, Error>) -> Void) {
        provider.rx.request(.updateLevel)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<User>.self)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func updateRank(completionHandler: @escaping (Result<Void, Error>) -> Void) {
        provider.rx.request(.updateRank)
            .filterSuccessfulStatusCodes()
            .subscribe { _ in
                completionHandler(.success(()))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
}
