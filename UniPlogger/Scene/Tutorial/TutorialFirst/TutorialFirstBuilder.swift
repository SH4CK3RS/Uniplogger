//
//  TutorialFirstBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol TutorialFirstDependency: Dependency {}

final class TutorialFirstComponent: Component<TutorialFirstDependency> {}

// MARK: - Builder

protocol TutorialFirstBuildable: Buildable {
    func build(withListener listener: TutorialFirstListener) -> TutorialFirstRouting
}

final class TutorialFirstBuilder: Builder<TutorialFirstDependency>, TutorialFirstBuildable {

    override init(dependency: TutorialFirstDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TutorialFirstListener) -> TutorialFirstRouting {
        let component = TutorialFirstComponent(dependency: dependency)
        let viewController = TutorialFirstViewController()
        let interactor = TutorialFirstInteractor(presenter: viewController)
        interactor.listener = listener
        return TutorialFirstRouter(interactor: interactor, viewController: viewController)
    }
}
