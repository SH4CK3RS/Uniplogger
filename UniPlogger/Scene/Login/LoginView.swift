//
//  LoginView.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum LoginViewAction {
    case accountChanged(String)
    case passwordChanged(String)
    case loginButtonTapped
    case registrationButtonTapped
    case findPasswordButtonTapped
}

protocol LoginViewListener: AnyObject {
    func action(_ action: LoginViewAction)
}

final class LoginView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: LoginViewListener?
    func activateLoginButton(_ isActive: Bool) {
        loginButton.isEnabled = isActive
        loginButton.backgroundColor = isActive ? .buttonEnabled : .buttonDisabled
    }
    
    // MARK: - Private
    private let scrollView = ScrollStackView()
    private let ploggerBackgroundImageView = UIImageView()
    private let formContainerView = UIView()
    private let accountFieldBox = UIView()
    private let accountField = UITextField()
    private let passwordFieldBox = UIView()
    private let passwordField = UITextField()
    private let loginButton = UIButton()
    private let findPasswordButton = UIButton()
    private let registrationButton = UIButton()
    
    @objc
    private func loginButtonTapped() {
        listener?.action(.loginButtonTapped)
    }
    
    @objc
    private func accountChanged(textField: UITextField) {
        let account = textField.text ?? ""
        listener?.action(.accountChanged(account))
    }
    
    @objc
    private func passwordChanged(textField: UITextField) {
        let password = textField.text ?? ""
        listener?.action(.passwordChanged(password))
    }
    
    @objc
    private func findPasswordButtonTapped() {
        listener?.action(.findPasswordButtonTapped)
    }
    
    @objc
    private func registrationButtonTapped() {
        listener?.action(.registrationButtonTapped)
    }
}

private extension LoginView {
    func setup() {
        backgroundColor = .loginRegistrationBackground
        scrollView.contentInset = .zero
        ploggerBackgroundImageView.do {
            $0.image = UIImage(named: "bg_loginPlogger")
            $0.contentMode = .scaleToFill
        }
        accountFieldBox.do {
            $0.backgroundColor = .formBoxBackground
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
        }
        accountField.do {
            $0.font = .notoSans(ofSize: 16, weight: .regular)
            $0.keyboardType = .emailAddress
            $0.autocapitalizationType = .none
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.placeholder = "아이디 (이메일)"
            $0.addTarget(self, action: #selector(accountChanged), for: .editingChanged)
        }
        passwordFieldBox.do {
            $0.backgroundColor = .formBoxBackground
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
        }
        passwordField.do {
            $0.font = .notoSans(ofSize: 16, weight: .regular)
            $0.isSecureTextEntry = true
            $0.textContentType = .password
            $0.keyboardType = .asciiCapable
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.placeholder = "비밀번호"
            $0.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        }
        loginButton.do {
            $0.setTitle("로그인", for: .normal)
            $0.backgroundColor = .buttonDisabled
            $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
            $0.isEnabled = false
            $0.layer.cornerRadius = 26
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
        findPasswordButton.do {
            $0.setTitle("비밀번호 찾기", for: .normal)
            $0.titleLabel?.font = .notoSans(ofSize: 14, weight: .regular)
            $0.setTitleColor(.text, for: .normal)
            $0.addTarget(self, action: #selector(findPasswordButtonTapped), for: .touchUpInside)
        }
        registrationButton.do {
            $0.setTitle("회원가입", for: .normal)
            $0.titleLabel?.font = .notoSans(ofSize: 14, weight: .regular)
            $0.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
            $0.setTitleColor(.text, for: .normal)
        }
        
        addSubview(scrollView)
        scrollView.addArrangedSubview(ploggerBackgroundImageView)
        scrollView.addArrangedSubview(formContainerView)
        formContainerView.addSubview(accountFieldBox)
        accountFieldBox.addSubview(accountField)
        formContainerView.addSubview(passwordFieldBox)
        passwordFieldBox.addSubview(passwordField)
        formContainerView.addSubview(loginButton)
        formContainerView.addSubview(findPasswordButton)
        formContainerView.addSubview(registrationButton)
    }
    
    func layout() {
        scrollView.containerView.snp.makeConstraints{
            $0.width.equalToSuperview()
        }
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
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
}
