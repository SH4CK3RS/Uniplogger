//
//  PloggingRecordBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs

protocol PloggingRecordDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PloggingRecordComponent: Component<PloggingRecordDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PloggingRecordBuildable: Buildable {
    func build(withListener listener: PloggingRecordListener) -> PloggingRecordRouting
}

final class PloggingRecordBuilder: Builder<PloggingRecordDependency>, PloggingRecordBuildable {

    override init(dependency: PloggingRecordDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PloggingRecordListener) -> PloggingRecordRouting {
        let component = PloggingRecordComponent(dependency: dependency)
        let viewController = PloggingRecordViewController()
        let interactor = PloggingRecordInteractor(presenter: viewController)
        interactor.listener = listener
        return PloggingRecordRouter(interactor: interactor, viewController: viewController)
    }
}
