//
//  PloggingRootBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol PloggingRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PloggingRootComponent: Component<PloggingRootDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PloggingRootBuildable: Buildable {
    func build(withListener listener: PloggingRootListener) -> PloggingRootRouting
}

final class PloggingRootBuilder: Builder<PloggingRootDependency>, PloggingRootBuildable {

    override init(dependency: PloggingRootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PloggingRootListener) -> PloggingRootRouting {
        let component = PloggingRootComponent(dependency: dependency)
        let viewController = PloggingRootViewController()
        let interactor = PloggingRootInteractor(presenter: viewController)
        interactor.listener = listener
        
        let ploggingMainBuilder = PloggingMainBuilder(dependency: component)
        let startCountingBuilder = StartCountingBuilder(dependency: component)
        return PloggingRootRouter(interactor: interactor,
                                  viewController: viewController,
                                  ploggingMainBuilder: ploggingMainBuilder,
                                  startCountingBuilder: startCountingBuilder)
    }
}
