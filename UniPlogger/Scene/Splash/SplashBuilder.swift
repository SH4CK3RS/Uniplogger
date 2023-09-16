//
//  SplashBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

protocol SplashBuildable {
    func build(withListener listener: SplashListener) -> SplashRouting
}

final class SplashBuilder: SplashBuildable {
    func build(withListener listener: SplashListener) -> SplashRouting {
        let viewController = SplashViewController()
        let interactor = SplashInteractor(presenter: viewController)
        interactor.listener = listener
        return SplashRouter(interactor: interactor, viewController: viewController)
    }
}

