//
//  ChallengeWorker.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/10/26.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class ChallengeWorker {
  
    func startChallenge(completion: @escaping (Planet) -> Void) {
        ChallengeAPI.shared.startChallenge { (result) in
            print("startChallenge")
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                let error = UniPloggerError.networkError(.responseError(error.localizedDescription))
            }
        }
    }
    
    func getPlanet(completion: @escaping (Planet) -> Void) {
        ChallengeAPI.shared.fetchPlanet { (response) in
            print("fetch")
            switch response {
            case .success(let value):
                if value.status == .success, let data = value.data {
                    guard let data = data else { return }
                    var user = AuthManager.shared.user
                    user?.planet = data
                    AuthManager.shared.user = user
                    completion(data)
                }
                
            case .failure(let error):
                let error = UniPloggerError.networkError(.responseError(error.localizedDescription))
            }
        }
    }

}
