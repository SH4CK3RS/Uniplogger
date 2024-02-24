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

protocol RegistrationRouting: BaseViewableRouting {
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
    case registrationFinished
}

protocol RegistrationListener: AnyObject {
    func request(_ request: RegistrationListenerRequest)
}

final class RegistrationInteractor: PresentableInteractor<RegistrationPresentable>, RegistrationInteractable, RegistrationPresentableListener {
    weak var listener: RegistrationListener?
    weak var router: RegistrationRouting?
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
            model.email = account
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
    private var model = RegistrationModel()
    
    private func handleRegistration() {
        UPLoader.shared.show()
        service.registration(model: model)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, response in
                UPLoader.shared.hidden()
                AuthManager.shared.userToken = response.token
                AuthManager.shared.user = response.user
                owner.listener?.request(.registrationFinished)
            } onFailure: { owner, error in
                UPLoader.shared.hidden()
                let errorMessage = error.localizedDescription
                owner.router?.request(.showErrorAlert(errorMessage))
            }.disposeOnDeactivate(interactor: self)
    }
}
