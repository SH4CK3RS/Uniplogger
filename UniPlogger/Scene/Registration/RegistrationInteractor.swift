//
//  RegistrationInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol RegistrationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum RegistrationPresentableRequest {
    case setNickname(String)
    case activateRegistrationButton(Bool)
}

protocol RegistrationPresentable: Presentable {
    var listener: RegistrationPresentableListener? { get set }
    func request(_ request: RegistrationPresentableRequest)
}

enum RegistrationListenerRequest {
    case back
    case close
}

protocol RegistrationListener: AnyObject {
    func request(_ request: RegistrationListenerRequest)
}

final class RegistrationInteractor: PresentableInteractor<RegistrationPresentable>, RegistrationInteractable, RegistrationPresentableListener {

    weak var router: RegistrationRouting?
    weak var listener: RegistrationListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: RegistrationPresentable,
         service: RegistrationServiceable,
         entryPoint: RegistrationEntryPoint) {
        self.service = service
        self.entryPoint = entryPoint
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func request(_ request: RegistrationPresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            if case let .tutorial(nickname) = entryPoint {
                model.nickname = nickname
                presenter.request(.setNickname(nickname))
            }
        case .backButtonTapped:
            listener?.request(.back)
        case .closeButtonTapped:
            listener?.request(.close)
        case let .accountChanged(account):
            model.nickname = account
            presenter.request(.activateRegistrationButton(model.isRegistrationButtonEnabled))
        case let .passwordChanged(password):
            model.password = password
            presenter.request(.activateRegistrationButton(model.isRegistrationButtonEnabled))
        case let .passwordConfirmChanged(passwordConfirm):
            model.passwordConfirm = passwordConfirm
            presenter.request(.activateRegistrationButton(model.isRegistrationButtonEnabled))
        case let .nicknameChanged(nickname):
            model.nickname = nickname
            presenter.request(.activateRegistrationButton(model.isRegistrationButtonEnabled))
        case .registrationButtonTapped:
            handleRegistration()
        }
    }
    
    private let service: RegistrationServiceable
    private let entryPoint: RegistrationEntryPoint
    private var model = RegistraionModel()
    
    private func handleRegistration() {
        UPLoader.shared.show()
        service.registration(model: model) {
            DispatchQueue.main.async {
                UPLoader.shared.hidden()
            }
        }
    }
}