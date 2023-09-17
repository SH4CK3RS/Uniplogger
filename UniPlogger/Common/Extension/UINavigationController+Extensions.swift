//
//  UINavigationController+Extensions.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

extension UINavigationController: ViewControllable {
    public var uiviewController: UIViewController { return self }
    
    public convenience init(root: ViewControllable) {
        self.init(rootViewController: root.uiviewController)
    }
    
    var isPresented: Bool {
        return presentingViewController != nil
    }
}
