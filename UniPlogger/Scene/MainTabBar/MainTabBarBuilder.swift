//
//  MainTabBarBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol MainTabBarDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class MainTabBarComponent: Component<MainTabBarDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol MainTabBarBuildable: Buildable {
    func build(withListener listener: MainTabBarListener) -> MainTabBarRouting
}

final class MainTabBarBuilder: Builder<MainTabBarDependency>, MainTabBarBuildable {

    override init(dependency: MainTabBarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MainTabBarListener) -> MainTabBarRouting {
        let component = MainTabBarComponent(dependency: dependency)
        let viewController = MainTabBarViewController()
        let interactor = MainTabBarInteractor(presenter: viewController)
        interactor.listener = listener
        let ploggingRootBuilder = PloggingRootBuilder(dependency: component)
        return MainTabBarRouter(interactor: interactor,
                                viewController: viewController,
                                ploggingRootBuilder: ploggingRootBuilder)
    }
}
