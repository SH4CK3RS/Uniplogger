//
//  FeedRootViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 10/28/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol FeedRootPresentableListener: AnyObject {
    
}

final class FeedRootViewController: UINavigationController, FeedRootPresentable, FeedRootViewControllable {

    weak var listener: FeedRootPresentableListener?
    
    func set(viewControllers: [ViewControllable], animated: Bool) {
        self.setViewControllers(viewControllers.map { $0.uiviewController }, animated: animated)
    }
    
    func push(viewController: ViewControllable, animated: Bool) {
        pushViewController(viewController.uiviewController, animated: animated)
    }
    
    func present(_ viewController: ViewControllable, animated: Bool) {
        present(viewController.uiviewController, animated: animated, completion: nil)
    }
    
    func dismiss(_ viewController: ViewControllable, animated: Bool) {
        guard presentedViewController === viewController.uiviewController else { return }
        dismiss(animated: animated)
    }
}
