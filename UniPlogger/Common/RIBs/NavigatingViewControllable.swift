//
//  NavigatingViewControllable.swift
//  UniPlogger
//
//  Created by ever on 2024/02/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol NavigatingViewControllable: ViewControllable {
    func present(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?)
    func present(_ viewController: ViewControllable, animated: Bool)
    func present(_ viewCOntroller: ViewControllable)
    func dismiss(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?)
    func dismiss(_ viewController: ViewControllable, animated: Bool)
    func dismiss(_ viewController: ViewControllable)
}

extension NavigatingViewControllable {
    func present(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?) {
        uiviewController.present(viewController.uiviewController, animated: animated, completion: completion)
    }
    func present(_ viewController: ViewControllable, animated: Bool) {
        present(viewController, animated: animated, completion: nil)
    }
    func present(_ viewCOntroller: ViewControllable) {
        present(viewCOntroller, animated: true)
    }
    
    func dismiss(_ viewController: ViewControllable, animated: Bool, completion: (() -> Void)?) {
        guard viewController.uiviewController === uiviewController.presentedViewController else { return }
        uiviewController.dismiss(animated: animated, completion: completion)
    }
    func dismiss(_ viewController: ViewControllable, animated: Bool) {
        dismiss(viewController, animated: animated, completion: nil)
    }
    func dismiss(_ viewController: ViewControllable) {
        dismiss(viewController, animated: true)
    }
}
