//
//  RegistrationViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum RegistrationPresentableListenerRequest {
    case viewDidLoad
    case accountChanged(String)
    case passwordChanged(String)
    case passwordConfirmChanged(String)
    case nicknameChanged(String)
    case registrationButtonTapped
}

protocol RegistrationPresentableListener: AnyObject {
    func request(_ request: RegistrationPresentableListenerRequest)
}

final class RegistrationViewController: UIViewController, RegistrationPresentable, RegistrationViewControllable {

    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        listener?.request(.viewDidLoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.accountField.becomeFirstResponder()
    }
    
    // MARK: - Internal
    weak var listener: RegistrationPresentableListener?
    
    // MARK: - Private
    private let mainView = RegistrationView()
    
    private func setupNavigation() {
        title = "회원가입"
        navigationController?.navigationBar.tintColor = .text
    }
    
    func request(_ request: RegistrationPresentableRequest) {
        switch request {
        case let .setNickname(nickname):
            mainView.setNickname(nickname)
        case let .activateRegistrationButton(isActive):
            mainView.activateRegistrationButton(isActive)
        }
    }
    
//    func displayFetchNickname(viewModel: Registration.FetchNickname.ViewModel) {
//        self.nicknameField.text = viewModel.nickname
//        self.validateNickname()
//    }
//    
//    func displayValidation(viewModel: Registration.ValidationViewModel) {
//        self.registrationButton.isEnabled = viewModel.isValid
//        self.registrationButton.backgroundColor = viewModel.isValid ? .buttonEnabled : .buttonDisabled
//    }
//    
//    func displayRegistration() {
//        UPLoader.shared.hidden()
//        self.router?.routeToSplash()
//    }
//    func displayError(error: Common.CommonError, useCase: Registration.UseCase){
//        //handle error with its usecase
//        UPLoader.shared.hidden()
//        switch error {
//        case .server(let msg):
//            self.errorAlert(title: "오류", message: msg, completion: nil)
//        case .local(let msg):
//            self.errorAlert(title: "오류", message: msg, completion: nil)
//        case .error(let error):
//            if let error = error as? (URLError) {
//                NetworkErrorManager.alert(error) { _ in
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
//                        guard let self = self else { return }
//                        switch useCase{
//                        case .Registration(let request):
//                            self.interactor?.registration(request: request)
//                        }
//                    }
//                }
//            } else if let error = error as? MoyaError{
//                NetworkErrorManager.alert(error)
//            }
//        }
//    }
}

extension RegistrationViewController: RegistrationViewListener {
    func action(_ action: RegistrationViewAction) {
        switch action {
        case let .accountChanged(account):
            listener?.request(.accountChanged(account))
        case let .passwordChanged(password):
            listener?.request(.passwordChanged(password))
        case let .passwordConfirmChanged(passwordConfirm):
            listener?.request(.passwordConfirmChanged(passwordConfirm))
        case let .nicknameChanged(nickname):
            listener?.request(.nicknameChanged(nickname))
        case .registrationButtonTapped:
            listener?.request(.registrationButtonTapped)
        }
    }
}
