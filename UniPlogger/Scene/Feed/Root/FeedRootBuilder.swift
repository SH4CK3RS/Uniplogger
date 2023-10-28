//
//  FeedRootBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 10/28/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol FeedRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FeedRootComponent: Component<FeedRootDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FeedRootBuildable: Buildable {
    func build(withListener listener: FeedRootListener) -> FeedRootRouting
}

final class FeedRootBuilder: Builder<FeedRootDependency>, FeedRootBuildable {

    override init(dependency: FeedRootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FeedRootListener) -> FeedRootRouting {
        let component = FeedRootComponent(dependency: dependency)
        let viewController = FeedRootViewController()
        let interactor = FeedRootInteractor(presenter: viewController)
        interactor.listener = listener
        let feedListBuilder = FeedListBuilder(dependency: component)
        return FeedRootRouter(interactor: interactor,
                              viewController: viewController,
                              feedListBuilder: feedListBuilder)
    }
}
