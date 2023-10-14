//
//  LoginInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift

protocol LoginRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

enum LoginPresentableRequest {
    case activateLoginButton(Bool)
    case showError(UniPloggerError)
}

protocol LoginPresentable: Presentable {
    var listener: LoginPresentableListener? { get set }
    func request(_ request: LoginPresentableRequest)
}

enum LoginListenerRequest {
    case loginFinished
    case registration
    case findPassword
}

protocol LoginListener: AnyObject {
    func request(_ request: LoginListenerRequest)
}

final class LoginInteractor: PresentableInteractor<LoginPresentable>, LoginInteractable, LoginPresentableListener {
    
    // in constructor.
    init(presenter: LoginPresentable,
         service: LoginServiceable) {
        self.service = service
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
    
    // MARK: - Internal
    weak var router: LoginRouting?
    weak var listener: LoginListener?
    
    func request(_ request: LoginPresentableListenerRequest) {
        switch request {
        case let .accountChanged(account):
            model.account = account
            presenter.request(.activateLoginButton(model.isLoginButtonEnabled))
        case let .passwordChanged(password):
            model.password = password
            presenter.request(.activateLoginButton(model.isLoginButtonEnabled))
        case .loginButtonTapped:
            handleLogin()
        case .registrationButtonTapped:
            handleRegistration()
        case .findPasswordButtonTapped:
            handleFindPassword()
        }
    }
    
    private let service: LoginServiceable
    private var model = LoginModel()
    
    private func handleLogin() {
        UPLoader.shared.show()
        service.login(model: model)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, response in
                UPLoader.shared.hidden()
                AuthManager.shared.userToken = response.token
                AuthManager.shared.user = response.user
                owner.listener?.request(.loginFinished)
            } onFailure: { owner, error in
                owner.presenter.request(.showError(UniPloggerError.networkError(.responseError(error.localizedDescription))))
            }.disposeOnDeactivate(interactor: self)
    }
    
    private func handleRegistration() {
        listener?.request(.registration)
    }
    
    private func handleFindPassword() {
        listener?.request(.findPassword)
    }
}
