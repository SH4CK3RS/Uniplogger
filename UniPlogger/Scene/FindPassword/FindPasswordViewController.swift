//
//  FindPasswordViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/12/11.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Moya

protocol FindPasswordDisplayLogic: AnyObject {
    func displayValidation(viewModel: FindPassword.ValidationViewModel)
    func displayFindPassword(viewModel: FindPassword.FindPassword.ViewModel)
    func displayError(error: UniPloggerError, useCase: FindPassword.UseCase)
}

class FindPasswordViewController: UIViewController, UIGestureRecognizerDelegate {
    var interactor: FindPasswordBusinessLogic?
    var router: (NSObjectProtocol & FindPasswordRoutingLogic & FindPasswordDataPassing)?
    
    let titleLabel = UILabel().then {
        $0.text = "비밀번호를 분실하셨나요?"
        $0.font = .notoSans(ofSize: 18, weight: .bold)
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "아이디를 입력해주세요"
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    
    let accountFieldBox = UIView().then {
        $0.backgroundColor = .formBoxBackground
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    lazy var accountField = UITextField().then {
        $0.font = .notoSans(ofSize: 16, weight: .regular)
        $0.keyboardType = .emailAddress
        $0.backgroundColor = .clear
        $0.borderStyle = .none
        $0.placeholder = "아이디 (이메일)"
        $0.addTarget(self, action: #selector(validateAccount), for: .editingChanged)
    }
    
    lazy var findPasswordButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
        $0.layer.cornerRadius = 26
        $0.backgroundColor = .buttonDisabled
        $0.isEnabled = false
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(findPasswordButtonTapped), for: .touchUpInside)
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
        let interactor = FindPasswordInteractor()
        let presenter = FindPasswordPresenter()
        let router = FindPasswordRouter()
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
        navigationController?.navigationBar.tintColor = .text
        self.view.backgroundColor = .mainBackgroundColor
        self.navigationItem.title = "비밀번호 찾기"
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        self.view.addSubview(accountFieldBox)
        accountFieldBox.addSubview(accountField)
        self.view.addSubview(findPasswordButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(22)
            $0.leading.equalTo(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(20)
        }
        
        accountFieldBox.snp.makeConstraints{
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(22)
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
        
        findPasswordButton.snp.makeConstraints {
            $0.top.equalTo(accountFieldBox.snp.bottom).offset(20)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(52)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.accountField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        (navigationController as? TutorialNavigationController)?.setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func validateAccount() {
        guard let text = accountField.text else { return }
        let request = FindPassword.ValidateAccount.Request(account: text)
        self.interactor?.validateAccount(request: request)
    }
    
    @objc func findPasswordButtonTapped() {
        guard let email = accountField.text, !email.isEmpty else {
            self.errorAlert(title: "오류", message: "이메일을 입력해주세요") { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.accountField.becomeFirstResponder()
                }
            }
            return
        }
        self.interactor?.findPassword(request: .init(email: email))
    }
}

extension FindPasswordViewController: FindPasswordDisplayLogic {
    func displayValidation(viewModel: FindPassword.ValidationViewModel) {
        self.findPasswordButton.isEnabled = viewModel.isValid
        self.findPasswordButton.backgroundColor = viewModel.isValid ? .buttonEnabled : .buttonDisabled
    }
    func displayFindPassword(viewModel: FindPassword.FindPassword.ViewModel) {
        UPLoader.shared.hidden()
        let alert = UIAlertController(title: "알림", message: viewModel.data, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func displayError(error: UniPloggerError, useCase: FindPassword.UseCase) {
        //handle error with its usecase
        UPLoader.shared.hidden()
    }
}
