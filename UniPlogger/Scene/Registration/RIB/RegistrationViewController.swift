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
    case backButtonTapped
    case closeButtonTapped
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

    private let entryPoint: RegistrationEntryPoint
    
    init(entryPoint: RegistrationEntryPoint) {
        self.entryPoint = entryPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        switch entryPoint {
        case .login:
            let backIcon = UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(backButtonTapped))
        case .tutorial:
            let closeIcon = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(closeButtonTapped))
        }
    }
    
    func request(_ request: RegistrationPresentableRequest) {
        switch request {
        case let .setNickname(nickname):
            mainView.setNickname(nickname)
        case let .activateRegistrationButton(isActive):
            mainView.activateRegistrationButton(isActive)
        }
    }
    
    @objc
    private func backButtonTapped() {
        listener?.request(.backButtonTapped)
    }
    
    @objc
    private func closeButtonTapped() {
        listener?.request(.closeButtonTapped)
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
