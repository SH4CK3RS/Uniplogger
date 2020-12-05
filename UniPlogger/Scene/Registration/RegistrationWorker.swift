//
//  RegistrationWorker.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/05.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class RegistrationWorker {
    func validateAccount(text: String) -> Bool{
        return text.count >= 1
    }
    
    func validatePassword(text: String) -> Bool{
        return text.count >= 1
    }
    
}
