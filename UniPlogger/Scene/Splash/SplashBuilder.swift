//
//  SplashBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol SplashDependency: Dependency {}

final class SplashComponent: Component<SplashDependency> {
    let splashViewController: SplashViewController
    
    init(dependency: SplashDependency,
         splashViewController: SplashViewController) {
        self.splashViewController = splashViewController
        super.init(dependency: dependency)
    }
}

protocol SplashBuildable {
    func build() -> LaunchRouting
}

final class SplashBuilder: Builder<SplashDependency>, SplashBuildable {
    func build() -> LaunchRouting {
        let viewController = SplashViewController()
        let component = SplashComponent(dependency: dependency,
                                        splashViewController: viewController)
        let interactor = SplashInteractor(presenter: viewController)
        
        return SplashRouter(interactor: interactor, viewController: viewController)
    }
}

