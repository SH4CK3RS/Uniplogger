//
//  RegistrationBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
enum RegistrationEntryPoint {
    case login
    case tutorial(String)
}
protocol RegistrationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class RegistrationComponent: Component<RegistrationDependency> {
    fileprivate var service: RegistrationServiceable {
        RegistrationService()
    }
}

// MARK: - Builder

protocol RegistrationBuildable: Buildable {
    func build(withListener listener: RegistrationListener,
               entryPoint: RegistrationEntryPoint) -> RegistrationRouting
}

final class RegistrationBuilder: Builder<RegistrationDependency>, RegistrationBuildable {

    override init(dependency: RegistrationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RegistrationListener, entryPoint: RegistrationEntryPoint) -> RegistrationRouting {
        let component = RegistrationComponent(dependency: dependency)
        let viewController = RegistrationViewController(entryPoint: entryPoint)
        let interactor = RegistrationInteractor(presenter: viewController,
                                                service: component.service,
                                                entryPoint: entryPoint)
        interactor.listener = listener
        return RegistrationRouter(interactor: interactor, viewController: viewController)
    }
}
