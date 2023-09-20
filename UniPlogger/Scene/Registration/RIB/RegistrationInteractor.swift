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

protocol RegistrationListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RegistrationInteractor: PresentableInteractor<RegistrationPresentable>, RegistrationInteractable, RegistrationPresentableListener {

    weak var router: RegistrationRouting?
    weak var listener: RegistrationListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: RegistrationPresentable,
         service: RegistrationServiceable,
         nickname: String?) {
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
        model.nickname = nickname ?? ""
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
            presenter.request(.setNickname(model.nickname))
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
