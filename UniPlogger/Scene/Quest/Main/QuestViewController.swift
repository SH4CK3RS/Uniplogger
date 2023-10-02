//
//  QuestViewController.swift
//  UniPlogger
//
//  Created by woong on 2020/09/29.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

protocol QuestDisplayLogic {
    func displayQuests(viewModel: QuestModels.ViewModel)
    func updateQuest(viewModel: QuestModels.ViewModel, at indexPath: IndexPath)
    func displayDetail(quest: Quest, recommads: [Quest])
}

final class QuestViewController: QuestBaseViewController {
    
    // MARK: - Constants
    
    private struct Metric {
        static let statusHeight: CGFloat = 91
        static let viewLeading: CGFloat = 16
        static let viewTrailing: CGFloat = -16
        static let verticalSpacing: CGFloat = 20
    }
    
    private struct Images {
        static let info = "ic_info"
    }
    
    // MARK: - Views
    
    private var titleLabel = UILabel().then {
        $0.text = "챌린지"
    }
    
    private var navigationTabsView = NavigationTabsView<QuestState>(items: [.todo, .doing, .done], tintColor: UIColor(named: "questTint")).then {
        $0.layer.masksToBounds = true
        $0.spacing = 1
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.configure(activeTextColor: .white, defaultTextColor: UIColor(named: "questNavigationTabText"))
        $0.selectedIndex = 0
    }
    
    private lazy var questTableView = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.contentInset = .init(top: 0, left: 0, bottom: Metric.verticalSpacing, right: 0)
        $0.showsVerticalScrollIndicator = false
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        $0.refreshControl = refreshControl
    }
    
    private lazy var infoBoxButton = UIBarButtonItem().then {
        $0.image = UIImage(named: Images.info)
        $0.target = self
        $0.action = #selector(touchedInfoButton(_:))
    }
    
    // MARK: - Properties
    
    private var questViewModel: QuestModels.ViewModel?
    private var interactor: QuestBusinessLogic?
    private(set) var router: (QuestDataPassing & QuestRoutingLogic)?
    private var currentQuestState: QuestState = .todo {
        didSet {
            interactor?.change(state: currentQuestState)
        }
    }
    
    // MARK: - Methods
    
    private func fetchData() {
        let request = QuestModels.Reqeust(state: currentQuestState)
        interactor?.fetchQuest(request: request)
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        setupViews()
        setupLayouts()
        
        if  UserDefaults.standard.bool(forDefines: .hasQuestTutorial) == false {
            let nav = UINavigationController()
            let t1 = QuestTutorialViewController1()
            nav.addChild(t1)
            nav.modalPresentationStyle = .fullScreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    // MARK: - Initialize
    
    func configureLogic(interactor: QuestBusinessLogic, router: (QuestRoutingLogic & QuestDataPassing)) {
        self.interactor = interactor
        self.router = router
    }
    
    private func setup() {
        navigationTabsView.tapHandler = { [weak self] state in
            self?.currentQuestState = state
        }
    }
    
    private func setupTableView() {
        questTableView.register(QuestTableViewCell.self, forCellReuseIdentifier: QuestTableViewCell.identifire)
        questTableView.dataSource = self
        questTableView.delegate = self
    }
    
    override func setupViews() {
        super.setupViews()
        title = "퀘스트"
        
        navigationItem.rightBarButtonItem = infoBoxButton
        backgroundView.addSubview(navigationTabsView)
        backgroundView.addSubview(questTableView)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        navigationTabsView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Metric.verticalSpacing)
            $0.leading.equalTo(backgroundView.snp.leading).offset(Metric.viewLeading)
            $0.trailing.equalTo(backgroundView.snp.trailing).offset(Metric.viewTrailing)
            $0.height.equalTo(42)
        }
        
        questTableView.snp.makeConstraints {
            $0.top.equalTo(navigationTabsView.snp.bottom).offset(Metric.verticalSpacing)
            $0.leading.equalTo(backgroundView.snp.leading).offset(Metric.viewLeading)
            $0.trailing.equalTo(backgroundView.snp.trailing).offset(Metric.viewTrailing)
            $0.bottom.equalTo(backgroundView.snp.bottom)
        }
    }
    
    // MARK: Selectors
    
    @objc private func pullToRefresh() {
        fetchData()
        questTableView.refreshControl?.endRefreshing()
    }
    
    @objc private func touchedInfoButton(_ sender: UIBarButtonItem) {
        let nav = UINavigationController()
        let t1 = QuestTutorialViewController1()
        nav.addChild(t1)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false, completion: nil)
    }
}

// MARK:  - Quest Display Logic

extension QuestViewController: QuestDisplayLogic {
    func displayDetail(quest: Quest, recommads: [Quest]) {
        UPLoader.shared.hidden()
        router?.routeToDetail(quest: quest, recommands: recommads)
    }
    
    func updateQuest(viewModel: QuestModels.ViewModel, at indexPath: IndexPath) {
        UPLoader.shared.hidden()
        questViewModel = viewModel
        
        questTableView.beginUpdates()
        questTableView.deleteRows(at: [indexPath], with: .fade)
        questTableView.endUpdates()
    }
    
    func displayQuests(viewModel: QuestModels.ViewModel) {
        UPLoader.shared.hidden()
        questViewModel = viewModel
        questTableView.reloadData()
    }
}

extension QuestViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questViewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questViewModel?.numberOfQuest(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestTableViewCell.identifire, for: indexPath) as? QuestTableViewCell,
              let questViewModel = questViewModel?.quest(at: indexPath)
        else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel: questViewModel)
        return cell
        
    }
}

extension QuestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        interactor?.showDetail(at: indexPath, state: currentQuestState)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return questViewModel?.height(at: indexPath) ?? .zero
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, completion) in
            
            completion(true)
            guard let self = self else { return }
            self.interactor?.touchedQuestAccessory(at: indexPath, state: self.currentQuestState)
        }
        
        let quest = questViewModel?.quest(at: indexPath)
        deleteAction.image = quest?.accessoryImage
        deleteAction.backgroundColor = Color.questBackground
        
        return .init(actions: [deleteAction])
    }
}
