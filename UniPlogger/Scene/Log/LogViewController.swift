//
//  LogViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/21.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LogDisplayLogic: class {
    func displayError(error: Common.CommonError, useCase: Log.UseCase)
}

class LogViewController: UIViewController, LogDisplayLogic {
    var interactor: LogBusinessLogic?
    var router: (NSObjectProtocol & LogRoutingLogic & LogDataPassing)?
    var scrollView = ScrollStackView()
    let ploggerContainer = UIImageView().then{
        $0.image = UIImage(named: "bg_logPloggerContainer")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    let ploggerImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_logPlogger")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    let yellowStarImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_logStarYellow")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    let levelTitleLabel = UILabel().then{
        $0.text = "레벨"
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let levelLabel = UILabel().then{
        $0.text = "2"
        $0.font = .notoSans(ofSize: 20, weight: .bold)
    }
    
    let rankTItleLabel = UILabel().then{
        $0.text = "상위"
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let rankLabel = UILabel().then{
        $0.text = "5%"
        $0.font = .notoSans(ofSize: 20, weight: .bold)
    }
    
    let pinkStarImageView = UIImageView().then{
        $0.image = UIImage(named: "ic_logStarPink")?.withRenderingMode(.alwaysOriginal)
        $0.contentMode = .scaleAspectFit
    }
    
    let statContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let statTitleLabel = UILabel().then {
        $0.text = "통계"
        $0.font = .notoSans(ofSize: 18, weight: .medium)
    }
    
    let statInnerContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let weeklyTitleLabel = UILabel().then {
        $0.text = "주간"
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let weeklyCircleView = UIView().then {
        $0.backgroundColor = .recordCellBackgroundColor
        $0.layer.cornerRadius = 41
    }
    let monthlyTitleLabel = UILabel().then {
        $0.text = "월간"
        $0.font = .notoSans(ofSize: 14, weight: .regular)
    }
    let monthlyCircleView = UIView().then {
        $0.backgroundColor = .recordCellBackgroundColor
        $0.layer.cornerRadius = 41
    }
    
    lazy var collectionView = IntrinsicSizeCollectionView(frame: .zero, collectionViewLayout: LogCollectionViewLayout()).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.register(LogCollectionViewCell.self, forCellWithReuseIdentifier: "LogCollectionViewCell")
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
        let interactor = LogInteractor()
        let presenter = LogPresenter()
        let router = LogRouter()
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
        configuration()
        setupView()
        setupLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func displayError(error: Common.CommonError, useCase: Log.UseCase){
        //handle error with its usecase
    }
}

extension LogViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogCollectionViewCell", for: indexPath) as? LogCollectionViewCell else { fatalError() }
        cell.viewModel = .init(image: "img_logSample\(indexPath.item + 1)")
        return cell
    }
}
