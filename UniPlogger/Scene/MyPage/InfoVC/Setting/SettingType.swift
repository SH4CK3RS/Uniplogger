//
//  SettingType.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/28.
//  Copyright © 2020 손병근. All rights reserved.
//

import Foundation

enum SettingType: Int, CaseIterable {
     case autosave = 0
    
    var description: String {
        switch self {
        case .autosave:
            return "사진자동저장"
        }
    }
    
}
