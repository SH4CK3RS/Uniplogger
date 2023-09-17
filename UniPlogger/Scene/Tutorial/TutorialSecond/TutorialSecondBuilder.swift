//
//  TutorialSecondBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol TutorialSecondDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class TutorialSecondComponent: Component<TutorialSecondDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TutorialSecondBuildable: Buildable {
    func build(withListener listener: TutorialSecondListener) -> TutorialSecondRouting
}

final class TutorialSecondBuilder: Builder<TutorialSecondDependency>, TutorialSecondBuildable {

    override init(dependency: TutorialSecondDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TutorialSecondListener) -> TutorialSecondRouting {
        let component = TutorialSecondComponent(dependency: dependency)
        let viewController = TutorialSecondViewController()
        let interactor = TutorialSecondInteractor(presenter: viewController)
        interactor.listener = listener
        return TutorialSecondRouter(interactor: interactor, viewController: viewController)
    }
}
