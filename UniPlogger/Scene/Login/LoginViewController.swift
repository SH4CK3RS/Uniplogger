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
import Moya

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: Internal
    weak var listener: LoginPresentableListener?
    
    func request(_ request: LoginPresentableRequest) {
        switch request {
        case let .activateLoginButton(isActive):
            mainView.activateLoginButton(isActive)
        case let .showError(error):
            showError(error)
        }
    }
    
    private let mainView = LoginView()
    
    private func showError(_ error: Common.CommonError){
        switch error {
        case let .server(msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case let .local(msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case let .error(error):
            if let error = error as? URLError {
                NetworkErrorManager.alert(error) { _ in }
            }
        }
    }
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
