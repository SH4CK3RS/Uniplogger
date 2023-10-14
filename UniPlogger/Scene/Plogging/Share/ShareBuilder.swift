//
//  ShareBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 10/8/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol ShareDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class ShareComponent: Component<ShareDependency> {
    fileprivate let feed: Feed
    
    init(dependency: ShareDependency, feed: Feed) {
        self.feed = feed
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ShareBuildable: Buildable {
    func build(withListener listener: ShareListener,feed: Feed) -> ShareRouting
}

final class ShareBuilder: Builder<ShareDependency>, ShareBuildable {

    override init(dependency: ShareDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ShareListener, feed: Feed) -> ShareRouting {
        let component = ShareComponent(dependency: dependency,
                                       feed: feed)
        let viewController = ShareViewController()
        let interactor = ShareInteractor(presenter: viewController,
                                         feed: component.feed)
        interactor.listener = listener
        return ShareRouter(interactor: interactor, viewController: viewController)
    }
}
