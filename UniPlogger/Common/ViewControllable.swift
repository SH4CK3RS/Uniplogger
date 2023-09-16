//
//  ViewControllable.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit

protocol ViewControllable: AnyObject {
    var uiviewController: UIViewController { get }
}

extension ViewControllable where Self: UIViewController {
    var uiviewController: UIViewController {
        return self
    }
}
