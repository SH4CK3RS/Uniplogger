//
//  PloggingAPI.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/12.
//  Copyright © 2020 손병근. All rights reserved.
//

import Moya
import RxSwift
import UIKit

struct PloggingAPI {
    private let disposeBag = DisposeBag()
    
    static let shared = PloggingAPI()
    private let provider = MoyaProvider<PloggingAPITarget>(
        stubClosure: MoyaProvider.immediatelyStub,
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func createTrashCan(latitude: Double, longitude: Double, address: String, completionHandler: @escaping (Result<BaseResponse<TrashCan>, Error>) -> Void) {
        provider.rx.request(.createTrash(latitude: latitude, longitude: longitude, address: address))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<TrashCan>.self)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
              completionHandler(.failure($0))
            }.disposed(by: disposeBag)
    }
    
    func fetchTrashList(completionHandler: @escaping (Result<BaseResponse<[TrashCan]>, Error>)-> Void) {
        provider.rx.request(.fetchTrashList)
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<[TrashCan]>.self)
            .subscribe(onSuccess: {
                completionHandler(.success($0))
            }, onFailure: { completionHandler(.failure($0)) })
            .disposed(by: disposeBag)
    }
    
    func deleteTrashCan(id: Int64, completionHandler: @escaping (Result<BaseResponse<TrashCan>, Error>) -> Void) {
        provider.rx.request(.deleteTrashCan(id: id))
            .filterSuccessfulStatusCodes()
            .map(BaseResponse<TrashCan>.self)
            .subscribe {
                completionHandler(.success($0))
            } onFailure: {
                completionHandler(.failure($0))
            }.disposed(by: self.disposeBag)
    }
    
    func uploadRecord(uid: Int, data: PloggingData, completionHandler: @escaping(Result<BaseResponse<Feed>, Error>) -> Void) {
        provider.rx.request(.uploadRecord(
            uid: uid,
            title: data.title,
            distance: data.distance,
            time: data.time,
            image: data.image!
        ))
        .filterSuccessfulStatusCodes()
        .map(BaseResponse<Feed>.self)
        .subscribe {
            completionHandler(.success($0))
        } onFailure: {
            print($0.localizedDescription)
            completionHandler(.failure($0))
        }.disposed(by: self.disposeBag)
    }
    
    // MARK: RxSwift
    func uploadRecord(data: PloggingData) -> Single<Feed> {
        guard let uid = AuthManager.shared.user?.id else { return Single.error(UniPloggerError.networkError(.requestBuildError("")))}
        return provider.rx.request(.uploadRecord(
            uid: uid,
            title: data.title,
            distance: data.distance,
            time: data.time,
            image: data.image!
        ))
        .map(BaseResponse<Feed>.self)
        .flatMap { response -> Single<Feed> in
            if let data = response.data {
                return .just(data)
            } else {
                return .error(UniPloggerError.networkError(.responseError(ErrorMessage.decodeError)))
            }
        }
    }
}


