//
//  LogModels.swift
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

enum Log {
    // MARK: Use cases
    
    enum UseCase {
        case GetUser
        case GetFeed
    }
    
    enum GetUser{
        struct Response {
            var response: User?
            var error: Common.CommonError?
        }
        
        struct ViewModel {
            var user: User
        }
    }
    
    enum GetFeed{
        struct Response {
            var feedList: [Feed]?
            var error: Common.CommonError?
        }
        
        struct ViewModel{
            var feedList: [Feed]
        }
    }
    
}
