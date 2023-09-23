//
//  RegistrationView.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/20.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit

enum RegistrationViewAction {
    case accountChanged(String)
    case passwordChanged(String)
    case passwordConfirmChanged(String)
    case nicknameChanged(String)
    case registrationButtonTapped
}

protocol RegistrationViewListener: AnyObject {
    func action(_ action: RegistrationViewAction)
}

final class RegistrationView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: RegistrationViewListener?
    func setNickname(_ nickname: String) {
        nicknameField.text = nickname
    }
    
    func activateRegistrationButton(_ isActive: Bool) {
        registrationButton.isEnabled = isActive
    }
    
    // MARK: - Private
    private let accountFieldBox = UIView()
    private let accountField = UITextField()
    private let passwordFieldBox = UIView()
    private let passwordField = UITextField()
    private let passwordInfoLabel = UILabel()
    private let passwordConfirmFieldBox = UIView()
    private let passwordConfirmField = UITextField()
    private let nicknameFieldBox = UIView()
    private let nicknameField = UITextField()
    private let registrationButton = UIButton()
    
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
    private func passwordConfirmChanged(textField: UITextField) {
        let passwordConfirm = textField.text ?? ""
        listener?.action(.passwordConfirmChanged(passwordConfirm))
    }
    
    @objc
    private func nicknameChanged(textField: UITextField) {
        let nickname = textField.text ?? ""
        listener?.action(.nicknameChanged(nickname))
    }
    
    @objc
    private func registrationButtonTapped() {
        listener?.action(.registrationButtonTapped)
    }
}

private extension RegistrationView {
    func setup() {
        backgroundColor = .loginRegistrationBackground
        accountFieldBox.do {
            $0.backgroundColor = .formBoxBackground
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
        }
        accountField.do {
            $0.font = .notoSans(ofSize: 16, weight: .regular)
            $0.keyboardType = .emailAddress
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
            $0.keyboardType = .asciiCapable
            $0.isSecureTextEntry = true
            $0.textContentType = .password
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.placeholder = "비밀번호"
            $0.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        }
        passwordInfoLabel.do {
            $0.text = "8~20자 이내의 영문과 숫자 조합을 입력해주세요"
            $0.textColor = UIColor(named: "color_registrationPasswordInfoLabel")
            $0.font = .dynamicNotosans(fontSize: 14, weight: .regular)
        }
        passwordConfirmFieldBox.do {
            $0.backgroundColor = .formBoxBackground
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
        }
        passwordConfirmField.do {
            $0.font = .notoSans(ofSize: 16, weight: .regular)
            $0.keyboardType = .asciiCapable
            $0.isSecureTextEntry = true
            $0.textContentType = .password
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.placeholder = "비밀번호 재입력"
            $0.addTarget(self, action: #selector(passwordConfirmChanged), for: .editingChanged)
        }
        nicknameFieldBox.do {
            $0.backgroundColor = .formBoxBackground
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
        }
        nicknameField.do {
            $0.font = .notoSans(ofSize: 16, weight: .regular)
            $0.backgroundColor = .clear
            $0.borderStyle = .none
            $0.placeholder = "닉네임"
            $0.addTarget(self, action: #selector(nicknameChanged), for: .editingChanged)
        }
        registrationButton.do {
            $0.setTitle("회원가입 완료", for: .normal)
            $0.backgroundColor = .buttonDisabled
            $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
            $0.isEnabled = false
            $0.layer.cornerRadius = 26
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(registrationButtonTapped), for: .touchUpInside)
        }
        
        addSubview(accountFieldBox)
        accountFieldBox.addSubview(accountField)
        addSubview(passwordFieldBox)
        passwordFieldBox.addSubview(passwordField)
        addSubview(passwordInfoLabel)
        addSubview(passwordConfirmFieldBox)
        passwordConfirmFieldBox.addSubview(passwordConfirmField)
        addSubview(nicknameFieldBox)
        nicknameFieldBox.addSubview(nicknameField)
        addSubview(registrationButton)
    }
    
    func layout() {
        accountFieldBox.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(22)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        accountField.snp.makeConstraints {
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        passwordFieldBox.snp.makeConstraints {
            $0.top.equalTo(accountFieldBox.snp.bottom).offset(12)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        passwordInfoLabel.snp.makeConstraints {
            $0.top.equalTo(passwordFieldBox.snp.bottom).offset(10)
            $0.leading.equalTo(passwordFieldBox).offset(27)
        }
        passwordConfirmFieldBox.snp.makeConstraints {
            $0.top.equalTo(passwordInfoLabel.snp.bottom).offset(10)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        passwordConfirmField.snp.makeConstraints {
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        nicknameFieldBox.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmFieldBox.snp.bottom).offset(12)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        nicknameField.snp.makeConstraints {
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        registrationButton.snp.makeConstraints {
            $0.top.equalTo(nicknameFieldBox.snp.bottom).offset(60)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
            $0.height.equalTo(52)
        }
    }
}
