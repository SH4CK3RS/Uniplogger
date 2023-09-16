//
//  LoginViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/05.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Then
import SnapKit
import Moya

protocol LoginDisplayLogic: AnyObject {
    func displayValidation(viewModel: Login.ValidationViewModel)
    func displayLogin()
    func displayError(error: Common.CommonError, useCase: Login.UseCase)
}

class LoginViewController: UIViewController {
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    let scrollView = ScrollStackView().then {
        $0.contentInset = .zero
    }
    
    let ploggerBackgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "bg_loginPlogger")
        $0.contentMode = .scaleToFill
    }
    
    let formContainerView = UIView()
    
    let accountFieldBox = UIView().then {
        $0.backgroundColor = .formBoxBackground
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    let accountField = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.keyboardType = .emailAddress
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.placeholder = "아이디 (이메일)"
        $0.addTarget(self, action: #selector(validateAccount), for: .editingChanged)
    }
    
    let passwordFieldBox = UIView().then {
        $0.backgroundColor = .formBoxBackground
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    let passwordField = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.isSecureTextEntry = true
        $0.textContentType = .password
        $0.keyboardType = .asciiCapable
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.placeholder = "비밀번호"
        $0.addTarget(self, action: #selector(validatePassword), for: .editingChanged)
    }
    
    lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .buttonDisabled
        $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
        $0.isEnabled = false
        $0.layer.cornerRadius = 26
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    lazy var findPasswordButton = UIButton().then{
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.titleLabel?.font = .notoSans(ofSize: 14, weight: .regular)
        $0.setTitleColor(.text, for: .normal)
        $0.addTarget(self, action: #selector(findPasswordButtonTapped), for: .touchUpInside)
    }
    
    lazy var registrationButton = UIButton().then{
        $0.setTitle("회원가입", for: .normal)
        $0.titleLabel?.font = .notoSans(ofSize: 14, weight: .regular)
        $0.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        $0.setTitleColor(.text, for: .normal)
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .loginRegistrationBackground
        self.view.addSubview(scrollView)
        scrollView.containerView.snp.makeConstraints{
            $0.width.equalTo(self.view)
        }
        
        scrollView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addArrangedSubview(ploggerBackgroundImageView)
        scrollView.addArrangedSubview(formContainerView)
        
        formContainerView.addSubview(accountFieldBox)
        accountFieldBox.addSubview(accountField)
        formContainerView.addSubview(passwordFieldBox)
        passwordFieldBox.addSubview(passwordField)
        formContainerView.addSubview(loginButton)
        formContainerView.addSubview(findPasswordButton)
        formContainerView.addSubview(registrationButton)
        
        ploggerBackgroundImageView.snp.makeConstraints {
            $0.height.equalTo(366)
        }
        
        accountFieldBox.snp.makeConstraints{
            $0.top.equalTo(36)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        accountField.snp.makeConstraints{
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        passwordFieldBox.snp.makeConstraints{
            $0.top.equalTo(accountFieldBox.snp.bottom).offset(12)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        passwordField.snp.makeConstraints{
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordFieldBox.snp.bottom).offset(32)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
            $0.height.equalTo(52)
        }
        
        findPasswordButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.leading.equalTo(20)
            $0.bottom.equalTo(-16)
        }
        
        registrationButton.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).offset(12)
            $0.trailing.equalTo(-20)
            $0.bottom.equalTo(-16)
        }
    }
    
    
    
    @objc func loginButtonTapped(){
        guard let account = accountField.text, !account.isEmpty,
              let password = passwordField.text, !password.isEmpty
        else { return }
        let request = Login.Login.Request(account: account, password: password)
        self.interactor?.login(request: request)
    }
    
    @objc func validateAccount(){
      guard let text = accountField.text else { return }
      let request = Login.ValidateAccount.Request(account: text)
      self.interactor?.validateAccount(request: request)
    }
    
    @objc func validatePassword(){
      guard let text = passwordField.text else { return }
      let request = Login.ValidatePassword.Request(password: text)
      self.interactor?.validatePassword(request: request)
    }
    
    @objc func findPasswordButtonTapped() {
        self.router?.routeToFindPassword()
    }
    
    @objc func registrationButtonTapped() {
        self.router?.routeToRegistration()
    }
    
}

extension LoginViewController: LoginDisplayLogic {
    func displayValidation(viewModel: Login.ValidationViewModel) {
        self.loginButton.isEnabled = viewModel.isValid
        self.loginButton.backgroundColor = viewModel.isValid ? .buttonEnabled : .buttonDisabled
    }
    
    func displayLogin() {
        UPLoader.shared.hidden()
        self.router?.routeToSplash()
    }
    
    func displayError(error: Common.CommonError, useCase: Login.UseCase){
        //handle error with its usecase
        UPLoader.shared.hidden()
        switch error {
        case .server(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .local(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .error(let error):
            if let error = error as? URLError {
                NetworkErrorManager.alert(error) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                        guard let self = self else { return }
                        switch useCase{
                        case .Login(let request):
                            self.interactor?.login(request: request)
                        }
                    }
                }
            } else if let error = error as? MoyaError {
                NetworkErrorManager.alert(error)
            }
            
        }
    }
    
}
