//
//  UserLogInteractor.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/30.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol UserLogBusinessLogic {
    func getFeed()
    func getOtherUser()
}

protocol UserLogDataStore {
    var playerId: Int? { get set }
}

class UserLogInteractor: UserLogBusinessLogic, UserLogDataStore {
    
    var playerId: Int?
    var presenter: UserLogPresentationLogic?
    var worker: UserLogWorker?
    private let disposeBag = DisposeBag()
    func getFeed() {
        guard let playerId = playerId else { return }
        let worker = UserLogWorker()
        self.worker = worker
        worker.getFeeds(uid: playerId)
            .subscribe(with: self) { owner, response in
                
            }
    }
    
    func getOtherUser() {
        UPLoader.shared.show()
        guard let playerId = playerId else {
            UPLoader.shared.hidden()
            return
        }
        worker = UserLogWorker()
        worker?.updateLevel {
            self.worker?.updateRank {
                self.worker?.getOtherUser(uid: playerId, completion: { (response) in
                    self.presenter?.presentUserInfo(response: response)
                })
            }
        }
        
    }
    
}
