//
//  LogOutViewController.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/25.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

class LogOutInfoViewController: InfoBaseViewController {

    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(LogOutInfoTableViewCell.self, forCellReuseIdentifier: LogOutInfoTableViewCell.ID)
        $0.isScrollEnabled = false
        $0.allowsSelection = true
        $0.backgroundColor = .clear
        $0.cellLayoutMarginsFollowReadableWidth = false
        $0.separatorInset.left = 0
        self.view.addSubview($0)
    }
    lazy var dimView = UIView().then {
        self.view.addSubview($0)
        $0.backgroundColor = UIColor(named: "reportDimColor")
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.questBackground
        setupLayout()
    }
    
}

extension LogOutInfoViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LogOutType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LogOutInfoTableViewCell.ID) as? LogOutInfoTableViewCell,
              let item = LogOutType.allCases[safe: indexPath.row] else { return UITableViewCell() }
        cell.configure(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let type = LogOutType.allCases[safe: indexPath.row] else { return }
        switch type {
        case .logOut:
            dimView.isHidden = false 
            showAlert()
        case .withdraw:
            self.navigationController?.pushViewController(WithdrawViewController(), animated: false)
        }
    }
    
    func showAlert() {
        let title = "아래 계정으로 다시 로그인 하실 수 있습니다."
        guard let message = AuthManager.shared.user?.email else { return }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: { _ in
            self.dimView.isHidden = true
            self.dismiss(animated: true, completion: nil)
        })
        let confirmAction = UIAlertAction(title: "로그아웃", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.logOut()
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        alertController.preferredAction = confirmAction
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logOut() {
        AuthAPI.shared.logout()
        AuthManager.shared.userToken = nil
        AuthManager.shared.user = nil
        AuthManager.shared.getPush = false
        AuthManager.shared.autoSave = false
        routeToSplash()
    }
    
    func routeToSplash() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            AuthManager.shared.logout()
            delegate.window?.rootViewController = SplashViewController()
            delegate.window?.makeKeyAndVisible()
        }
    }

}

extension LogOutInfoViewController {
    
    func setupLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(98)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(104.5)
        }
        dimView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
}
