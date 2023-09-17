//
//  TutorialRootBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/17.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol TutorialRootDependency: Dependency {
    var tutorialRootViewController: TutorialRootViewControllable { get }
}

final class TutorialRootComponent: Component<TutorialRootDependency> {
    fileprivate var tutorialRootViewController: TutorialRootViewControllable {
        return dependency.tutorialRootViewController
    }
}

// MARK: - Builder

protocol TutorialRootBuildable: Buildable {
    func build(withListener listener: TutorialRootListener) -> TutorialRootRouting
}

final class TutorialRootBuilder: Builder<TutorialRootDependency>, TutorialRootBuildable {

    override init(dependency: TutorialRootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TutorialRootListener) -> TutorialRootRouting {
        let component = TutorialRootComponent(dependency: dependency)
        let interactor = TutorialRootInteractor()
        interactor.listener = listener
        
        let tutiroaiFirstBuilder = TutorialFirstBuilder(dependency: component)
        return TutorialRootRouter(interactor: interactor,
                                  viewController: component.tutorialRootViewController,
                                  tutorialFirstBuilder: tutiroaiFirstBuilder)
    }
}
