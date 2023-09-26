//
//  PloggingRootViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol PloggingRootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class PloggingRootViewController: UINavigationController, PloggingRootPresentable, PloggingRootViewControllable {

    weak var listener: PloggingRootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
    }
    
    func set(viewControllers: [ViewControllable], animated: Bool) {
        self.setViewControllers(viewControllers.map { $0.uiviewController }, animated: animated)
    }
    
    func push(viewController: ViewControllable, animated: Bool) {
        pushViewController(viewController.uiviewController, animated: animated)
    }
}
