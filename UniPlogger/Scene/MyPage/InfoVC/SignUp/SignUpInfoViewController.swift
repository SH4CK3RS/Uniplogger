//
//  SignUpInfoViewController.swift
//  UniPlogger
//
//  Created by 고세림 on 2020/11/25.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

final class SignUpInfoViewController: InfoBaseViewController {

    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(SignUpTableViewCell.self, forCellReuseIdentifier: SignUpTableViewCell.ID)
        $0.isScrollEnabled = false
        $0.allowsSelection = true
        $0.backgroundColor = .clear
        $0.cellLayoutMarginsFollowReadableWidth = false
        $0.separatorInset.left = 0
        self.view.addSubview($0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.questBackground
        setupLayout()
    }
    
}

extension SignUpInfoViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SignUpInfoType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SignUpTableViewCell.ID) as? SignUpTableViewCell else { return UITableViewCell() }
        cell.configure(item: SignUpInfoType.allCases[indexPath.row])
        return cell
    }

}

extension SignUpInfoViewController {
    
    func setupLayout() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(98)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(156.5)
        }
    }
    
}
