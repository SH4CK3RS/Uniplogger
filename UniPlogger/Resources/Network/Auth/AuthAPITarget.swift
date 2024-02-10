//
//  AuthAPITarget.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/24.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation
import Moya

enum AuthAPITarget {
    //쓰레기통 CRUD
    case login(email: String, password: String)
    case logout
    case withdraw(uid: Int)
    case registration(email: String, password1: String, password2: String, nickname: String)
    case findPassword(email: String)
    case initQuest
    case resetPassword(password1: String, password2: String, uid: String, token: String)
}

extension AuthAPITarget: BaseTarget {
    var path: String{
        switch self{
        case .login:
            return "auth/signIn"
        case .logout:
            return "auth/logout"
        case let .withdraw(uid):
            return "auth/\(uid)"
        case .registration:
            return "auth/signUp"
        case .findPassword:
            return "auth/password/reset"
        case .initQuest:
            return "auth/quest_to_user"
        case .resetPassword:
            return "auth/password/reset/confirm"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .login:
            return .post
        case .logout:
            return .post
        case .withdraw:
            return .delete
        case .registration:
            return .post
        case .findPassword:
            return .post
        case .initQuest:
            return .get
        case .resetPassword:
            return .post
        }
    }
    
    var parameters: [String : Any]{
        switch self{
        case let .login(email, password):
            return [
              "email": email,
              "password": password
            ]
        case .logout:
            return [:]
        case let .withdraw(uid):
            return [
                "id":uid
            ]
        case let .registration(email, password1, password2, nickname):
            return [
                "email": email,
                "password1": password1,
                "password2": password2,
                "nickname": nickname
            ]
        case let .findPassword(email):
            return [
                "email": email
            ]
        case .initQuest:
            return [:]
        case let .resetPassword(password1, password2, uid, token):
            return [
                "new_password1": password1,
                "new_password2": password2,
                "uid": uid,
                "token": token
            ]
        }
        
    }
    
    var task: Task{
        switch self{
        case .login:
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .logout:
            return .requestPlain
        case .withdraw:
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .registration:
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .findPassword:
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .initQuest:
            return .requestPlain
        case .resetPassword:
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
    }
    
    var sampleData: Data {
      switch self {
      case .login:
          if let url = Bundle.main.url(forResource: "LoginResponse", withExtension: "json"),
             let data = try? Data(contentsOf: url) {
              return data
          }
          return Data()
      default:
        return Data()
      }
    }
    
}
