//
//  ResetPasswordViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/13.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ResetPasswordDisplayLogic: class {
    func displayResetPassword(viewModel: ResetPassword.ResetPassword.ViewModel)
    func displayError(error: Common.CommonError, useCase: ResetPassword.UseCase)
}

class ResetPasswordViewController: UIViewController {
    var interactor: ResetPasswordBusinessLogic?
    var router: (NSObjectProtocol & ResetPasswordRoutingLogic & ResetPasswordDataPassing)?
    
    let titleLabel = UILabel().then {
        $0.text = "새 비밀번호를 입력하세요"
        $0.font = .notoSans(ofSize: 18, weight: .bold)
    }
    
    let cautionLabel = UILabel().then {
        $0.text = "8~20자 이내의 영문과 숫자 조합을 입력해주세요"
        $0.textColor = UIColor(named: "color_registrationPasswordInfoLabel")
        $0.font = .dynamicNotosans(fontSize: 14, weight: .regular)
    }
    
    let password1FieldBox = UIView().then {
        $0.backgroundColor = .formBoxBackground
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    let password1Field = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.keyboardType = .asciiCapable
        $0.isSecureTextEntry = true
        $0.textContentType = .password
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.attributedPlaceholder = NSMutableAttributedString().string("비밀번호", font: .notoSans(ofSize: 16, weight: .regular), color: .white)
    }
    
    let password2FieldBox = UIView().then {
        $0.backgroundColor = .formBoxBackground
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    let password2Field = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.keyboardType = .asciiCapable
        $0.isSecureTextEntry = true
        $0.textContentType = .password
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.attributedPlaceholder = NSMutableAttributedString().string("비밀번호 재입력", font: .notoSans(ofSize: 16, weight: .regular), color: .white)
    }
    
    lazy var resetPasswordButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.backgroundColor = .buttonEnabled
        $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
        $0.layer.cornerRadius = 26
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(resetPasswordButtonTapped), for: .touchUpInside)
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
        let interactor = ResetPasswordInteractor()
        let presenter = ResetPasswordPresenter()
        let router = ResetPasswordRouter()
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
        self.view.backgroundColor = .mainBackgroundColor
        self.navigationItem.title = "비밀번호 찾기"
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(cautionLabel)
        self.view.addSubview(password1FieldBox)
        password1FieldBox.addSubview(password1Field)
        self.view.addSubview(password2FieldBox)
        password2FieldBox.addSubview(password2Field)
        self.view.addSubview(resetPasswordButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(22)
            $0.leading.equalTo(20)
        }
        
        password1FieldBox.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(22)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        password1Field.snp.makeConstraints{
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        cautionLabel.snp.makeConstraints{
            $0.top.equalTo(password1FieldBox.snp.bottom).offset(10)
            $0.leading.equalTo(password1FieldBox
            ).offset(27)
        }
        
        password2FieldBox.snp.makeConstraints{
            $0.top.equalTo(cautionLabel.snp.bottom).offset(10)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        
        password2Field.snp.makeConstraints{
            $0.top.equalTo(12)
            $0.bottom.equalTo(-12)
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
        }
        
        resetPasswordButton.snp.makeConstraints {
            $0.top.equalTo(password2FieldBox.snp.bottom).offset(32)
            $0.leading.equalTo(18)
            $0.trailing.equalTo(-18)
            $0.height.equalTo(52)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.password1Field.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func resetPasswordButtonTapped() {
        guard let password1 = password1Field.text, !password1.isEmpty,
              let password2 = password2Field.text, !password2.isEmpty
        else {
            return
        }
        
        let request = ResetPassword.ResetPassword.Request(password1: password1, password2: password2)
        self.interactor?.resetPassword(request: request)
    }
}

extension ResetPasswordViewController: ResetPasswordDisplayLogic {
    func displayResetPassword(viewModel: ResetPassword.ResetPassword.ViewModel) {
        let alert = UIAlertController(title: "알림", message: viewModel.detail, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayError(error: Common.CommonError, useCase: ResetPassword.UseCase){
        //handle error with its usecase
        switch error {
        case .server(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .local(let msg):
            self.errorAlert(title: "오류", message: msg, completion: nil)
        case .error(let error):
            guard let error = error as? URLError else { return }
            NetworkErrorManager.alert(error) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                    guard let self = self else { return }
                    switch useCase{
                    case .ResetPassword(let request):
                        self.interactor?.resetPassword(request: request)
                    }
                }
            }
        }
    }
}
