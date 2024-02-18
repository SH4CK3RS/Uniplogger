//
//  CommonPopupBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2/12/24.
//  Copyright © 2024 손병근. All rights reserved.
//

import RIBs

protocol CommonPopupDependency: Dependency {}

final class CommonPopupComponent: Component<CommonPopupDependency> {
    let viewTypes: [CommonPopupView.ViewType]
    init(dependency: CommonPopupDependency, viewTypes: [CommonPopupView.ViewType]) {
        self.viewTypes = viewTypes
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol CommonPopupBuildable: Buildable {
    func build(withListener listener: CommonPopupListener, viewTypes: [CommonPopupView.ViewType]) -> CommonPopupRouting
}

final class CommonPopupBuilder: Builder<CommonPopupDependency>, CommonPopupBuildable {

    override init(dependency: CommonPopupDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CommonPopupListener, viewTypes: [CommonPopupView.ViewType]) -> CommonPopupRouting {
        let component = CommonPopupComponent(dependency: dependency, viewTypes: viewTypes)
        let viewController = CommonPopupViewController(viewTypes: component.viewTypes)
        let interactor = CommonPopupInteractor(presenter: viewController)
        interactor.listener = listener
        return CommonPopupRouter(interactor: interactor, viewController: viewController)
    }
}
