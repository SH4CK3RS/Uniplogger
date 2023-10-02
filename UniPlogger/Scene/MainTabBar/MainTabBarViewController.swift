//
//  MainTabBarViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit

enum MainTabBarPresentableListenerRequest {
    case viewDidAppear
}

protocol MainTabBarPresentableListener: AnyObject {
    func request(_ request: MainTabBarPresentableListenerRequest)
}

final class MainTabBarViewController: UITabBarController, MainTabBarPresentable, MainTabBarViewControllable {

    weak var listener: MainTabBarPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        setupView()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.request(.viewDidAppear)
    }
    
    private let tabbarBackgroundView = RoundShadowView()
    
    
    func set(viewControllers: [ViewControllable]) {
        setViewControllers(viewControllers.map { $0.uiviewController } , animated: true)
    }
}

private extension MainTabBarViewController {
    private func configuration() {
        self.view.backgroundColor = .white
        self.tabBar.barTintColor = .tabbarNavbar
        self.tabBar.tintColor = .buttonEnabled
        self.tabBar.unselectedItemTintColor = .tabBarUnselectedTint
    }
    
    private func setupView() {
        tabBar.do {
            $0.backgroundImage = UIImage.from(color: .clear)
            $0.shadowImage = UIImage()
            $0.backgroundColor = .tabbarNavbar
            $0.layer.cornerRadius = 22
        }
        tabbarBackgroundView.do {
            $0.layer.cornerRadius = 22
            $0.backgroundColor = .tabbarNavbar
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        tabBar.insertSubview(tabbarBackgroundView, at: 0)
//        setupQuestViewController()
//        setupChallengeViewController()
//        setupPloggingViewController()
//        setupLogViewController()
//        setupMyViewController()
//
//        self.selectedIndex = 2
    }
    
    private func setupLayout() {
        tabbarBackgroundView.snp.makeConstraints {
            $0.edges.equalTo(tabBar)
        }
    }
    
    private func updateView() {
        
    }
    
    private func setupChallengeViewController() {
        let challengeItem = UITabBarItem(title: "챌린지", image: UIImage(named: "tabbar_challenge"), tag: 0)
        let vc = ChallengeNavigationController(rootViewController: hasPlanet() ?  ChallengeViewController() : StartViewController())
        vc.isNavigationBarHidden = true
        vc.tabBarItem = challengeItem
        self.addChild(vc)
    }
    
    private func setupQuestViewController() {
        let questItem = UITabBarItem(title: "퀘스트", image: UIImage(named: "tabbar_quest"), tag: 1)
        let questNavVC = QuestNavigationController()
        let questVC = QuestViewController()
        questNavVC.addChild(questVC)
        
        let presenter = QuestPresenter(viewController: questVC, questFactory: QuestFactory())
        let worker = QuestWorker()
        let storage = Storage()
        let interactor = QuestInteractor(presenter: presenter, worker: worker, questManager: QuestManager(questChecker: QuestChecker(storage: storage), storage: storage))
        let router = QuestRouter(viewController: questVC, dataStore: interactor)
        questVC.configureLogic(interactor: interactor, router: router)
        questNavVC.tabBarItem = questItem
        self.addChild(questNavVC)
    }
    
    private func setupPloggingViewController() {
        let ploggingItem = UITabBarItem(title: "플로깅", image: UIImage(named: "tabbar_plogging"), tag: 2)
        let vc = PloggingViewController()
        vc.tabBarItem = ploggingItem
        self.addChild(vc)
    }
    
    private func setupLogViewController() {
        let logItem = UITabBarItem(title: "로그", image: UIImage(named: "tabbar_log"), tag: 3)
        let logVC = LogViewController()
        var destinationDS = logVC.router?.dataStore
        destinationDS?.uid = AuthManager.shared.user?.id
        let logNavVC = LogNavigationController(rootViewController: logVC)
        logNavVC.tabBarItem = logItem
        self.addChild(logNavVC)
    }
    
    private func setupMyViewController() {
        let myItem = UITabBarItem(title: "마이", image: UIImage(named: "tabbar_my"), tag: 4)
        let vc = MyPageNavigationController(rootViewController: MyPageViewController())
        vc.tabBarItem = myItem
        self.addChild(vc)
    }
    
    private func hasPlanet() -> Bool {
        if AuthManager.shared.user?.planet == nil { return false }
        return true
    }
}

