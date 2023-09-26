//
//  PloggingMainBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol PloggingMainDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PloggingMainComponent: Component<PloggingMainDependency> {
    fileprivate var locationManager: LocationManagable {
        LocationManager()
    }
}

// MARK: - Builder

protocol PloggingMainBuildable: Buildable {
    func build(withListener listener: PloggingMainListener) -> PloggingMainRouting
}

final class PloggingMainBuilder: Builder<PloggingMainDependency>, PloggingMainBuildable {

    override init(dependency: PloggingMainDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PloggingMainListener) -> PloggingMainRouting {
        let component = PloggingMainComponent(dependency: dependency)
        let viewController = PloggingMainViewController()
        let interactor = PloggingMainInteractor(presenter: viewController,
                                                locationManager: component.locationManager)
        interactor.listener = listener
        return PloggingMainRouter(interactor: interactor, viewController: viewController)
    }
}
