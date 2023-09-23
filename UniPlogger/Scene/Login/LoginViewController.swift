//
//  LoginViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum LoginPresentableListenerRequest {
    case accountChanged(String)
    case passwordChanged(String)
    case loginButtonTapped
    case registrationButtonTapped
    case findPasswordButtonTapped
}

protocol LoginPresentableListener: AnyObject {
    func request(_ request: LoginPresentableListenerRequest)
}

final class LoginViewController: UIViewController, LoginPresentable, LoginViewControllable {

    
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    // MARK: Internal
    weak var listener: LoginPresentableListener?
    
    func request(_ request: LoginPresentableRequest) {
        switch request {
        case let .activateLoginButton(isActive):
            mainView.activateLoginButton(isActive)
        }
    }
    
    private let mainView = LoginView()
//    func displayValidation(viewModel: Login.ValidationViewModel) {
//        self.loginButton.isEnabled = viewModel.isValid
//        self.loginButton.backgroundColor = viewModel.isValid ? .buttonEnabled : .buttonDisabled
//    }
//    
//    func displayLogin() {
//        UPLoader.shared.hidden()
//        self.router?.routeToSplash()
//    }
//    
//    func displayError(error: Common.CommonError, useCase: Login.UseCase){
//        //handle error with its usecase
//        UPLoader.shared.hidden()
//        switch error {
//        case .server(let msg):
//            self.errorAlert(title: "오류", message: msg, completion: nil)
//        case .local(let msg):
//            self.errorAlert(title: "오류", message: msg, completion: nil)
//        case .error(let error):
//            if let error = error as? URLError {
//                NetworkErrorManager.alert(error) { _ in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
//                        guard let self = self else { return }
//                        switch useCase{
//                        case .Login(let request):
//                            self.interactor?.login(request: request)
//                        }
//                    }
//                }
//            } else if let error = error as? MoyaError {
//                NetworkErrorManager.alert(error)
//            }
//            
//        }
//    }
}

extension LoginViewController: LoginViewListener{
    func action(_ action: LoginViewAction) {
        switch action {
        case let .accountChanged(account):
            listener?.request(.accountChanged(account))
        case let .passwordChanged(password):
            listener?.request(.passwordChanged(password))
        case .loginButtonTapped:
            listener?.request(.loginButtonTapped)
        case .registrationButtonTapped:
            listener?.request(.registrationButtonTapped)
        case .findPasswordButtonTapped:
            listener?.request(.findPasswordButtonTapped)
        }
    }
}
