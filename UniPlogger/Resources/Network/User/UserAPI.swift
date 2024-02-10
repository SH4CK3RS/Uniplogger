//
//  UserAPI.swift
//  UniPlogger
//
//  Created by 손병근 on 2/10/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import Moya
import RxSwift

struct UserAPI {
    let disposeBag = DisposeBag()
    
    static let shared = UserAPI()
    private init() {}
    private let provider = MoyaProvider<UserAPITarget>(
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
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
    
    func getUser(uid: Int) -> Single<User> {
        provider.rx.request(.getUser(uid: uid))
            .map(BaseResponse<User>.self)
            .flatMap { response -> Single<User> in
                if let data = response.data {
                    return .just(data)
                } else {
                    return .error(UniPloggerError.networkError(.responseError(ErrorMessage.decodeError)))
                }
            }
    }
}
