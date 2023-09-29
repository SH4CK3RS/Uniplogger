//
//  StartCountingBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol StartCountingDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class StartCountingComponent: Component<StartCountingDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol StartCountingBuildable: Buildable {
    func build(withListener listener: StartCountingListener) -> StartCountingRouting
}

final class StartCountingBuilder: Builder<StartCountingDependency>, StartCountingBuildable {

    override init(dependency: StartCountingDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: StartCountingListener) -> StartCountingRouting {
        let component = StartCountingComponent(dependency: dependency)
        let viewController = StartCountingViewController()
        let interactor = StartCountingInteractor(presenter: viewController)
        interactor.listener = listener
        return StartCountingRouter(interactor: interactor, viewController: viewController)
    }
}
