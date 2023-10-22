//
//  FeedListBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol FeedListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FeedListComponent: Component<FeedListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FeedListBuildable: Buildable {
    func build(withListener listener: FeedListListener) -> FeedListRouting
}

final class FeedListBuilder: Builder<FeedListDependency>, FeedListBuildable {

    override init(dependency: FeedListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: FeedListListener) -> FeedListRouting {
        let component = FeedListComponent(dependency: dependency)
        let viewController = FeedListViewController()
        let interactor = FeedListInteractor(presenter: viewController)
        interactor.listener = listener
        return FeedListRouter(interactor: interactor, viewController: viewController)
    }
}
