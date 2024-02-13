//
//  TrashCanAPI.swift
//  UniPlogger
//
//  Created by 손병근 on 2/10/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import Moya
import RxSwift

struct TrashCanAPI {
    let disposeBag = DisposeBag()
    
    static let shared = TrashCanAPI()
    private init() {}
    private let provider = MoyaProvider<TrashCanAPITarget>(
        session: SessionManager.shared,
        plugins: [VerbosePlugin(verbose: true)]
    )
    
    func getTrashCans() -> Single<[TrashCan]> {
        provider.rx.request(.getTrashCans)
            .handleResponse()
    }
    
    func addTrashCan(requestDTO: TrashCanRequestDTO) -> Single<TrashCan> {
        provider.rx.request(.addTrashCan(requestDTO: requestDTO))
            .handleResponse()
    }
}
