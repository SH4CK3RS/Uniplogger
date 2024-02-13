//
//  PrimitiveSequence+Extensions.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func handleResponse<T: Codable>() -> Single<T> {
        return flatMap { response -> Single<T> in
            if 200..<300 ~= response.statusCode {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedResponse = try filteredResponse.map(BaseResponse<T>.self)
                    if let data = decodedResponse.data {
                        return .just(data)
                    } else {
                        return .error(UniPloggerError.networkError(.responseError(ErrorMessage.decodeError)))
                    }
                } catch {
                    return .error(error)
                }
            } else {
                do {
                    let errorResponse = try response.map(ErrorResponse.self)
                    return .error(UniPloggerError.networkError(.responseError(errorResponse.reason)))
                } catch {
                    return .error(UniPloggerError.networkError(.responseError("알 수 없는 오류")))
                }
            }
        }
    }
}
