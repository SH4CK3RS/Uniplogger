//
//  TutorialThirdBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol TutorialThirdDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TutorialThirdComponent: Component<TutorialThirdDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TutorialThirdBuildable: Buildable {
    func build(withListener listener: TutorialThirdListener) -> TutorialThirdRouting
}

final class TutorialThirdBuilder: Builder<TutorialThirdDependency>, TutorialThirdBuildable {

    override init(dependency: TutorialThirdDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TutorialThirdListener) -> TutorialThirdRouting {
        let component = TutorialThirdComponent(dependency: dependency)
        let viewController = TutorialThirdViewController()
        let interactor = TutorialThirdInteractor(presenter: viewController)
        interactor.listener = listener
        return TutorialThirdRouter(interactor: interactor, viewController: viewController)
    }
}
