//
//  LogInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/21.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LogBusinessLogic {
    func getUser()
    func getFeed()
}

protocol LogDataStore {
    var uid: Int? { get set }
}

class LogInteractor: LogBusinessLogic, LogDataStore {
    var uid: Int?
    var presenter: LogPresentationLogic?
    var worker = LogWorker()
    //var name: String = ""
    
    func getUser() {
        UPLoader.shared.show()
        self.worker.updateRank {
            self.worker.updateLevel { [weak self] (response) in
                self?.presenter?.presentGetUser(response: response)
            }
        }
    }
    func getFeed() {
        guard let uid = self.uid else {
            let response = Log.GetFeed.Response(error: .other(reason: "유저 정보를 확인할 수 없습니다."))
            self.presenter?.presentGetFeed(response: response)
            return
        }
    }
}
