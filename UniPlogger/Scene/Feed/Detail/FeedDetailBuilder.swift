//
//  FeedDetailBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol FeedDetailDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FeedDetailComponent: Component<FeedDetailDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FeedDetailBuildable: Buildable {
    func build(withListener listener: FeedDetailListener) -> FeedDetailRouting
}

final class FeedDetailBuilder: Builder<FeedDetailDependency>, FeedDetailBuildable {

    override init(dependency: FeedDetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FeedDetailListener) -> FeedDetailRouting {
        let component = FeedDetailComponent(dependency: dependency)
        let viewController = FeedDetailViewController()
        let interactor = FeedDetailInteractor(presenter: viewController)
        interactor.listener = listener
        return FeedDetailRouter(interactor: interactor, viewController: viewController)
    }
}
