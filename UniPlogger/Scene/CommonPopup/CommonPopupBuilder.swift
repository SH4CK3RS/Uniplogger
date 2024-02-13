//
//  CommonPopupBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs

protocol CommonPopupDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class CommonPopupComponent: Component<CommonPopupDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CommonPopupBuildable: Buildable {
    func build(withListener listener: CommonPopupListener) -> CommonPopupRouting
}

final class CommonPopupBuilder: Builder<CommonPopupDependency>, CommonPopupBuildable {

    override init(dependency: CommonPopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CommonPopupListener) -> CommonPopupRouting {
        let component = CommonPopupComponent(dependency: dependency)
        let viewController = CommonPopupViewController()
        let interactor = CommonPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return CommonPopupRouter(interactor: interactor, viewController: viewController)
    }
}
