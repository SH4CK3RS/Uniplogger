//
//  FeedListView.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum FeedListViewAction {
    case pullToRefresh
    case feedSelected(Feed)
}

protocol FeedListViewListener: AnyObject {
    func action(_ action: FeedListViewAction)
}

final class FeedListView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: FeedListViewListener?
    
    // MARK: - Private
    private let scrollView = ScrollStackView()
    private let levelRankingView = FeedListLevelRankingView()
    private let statViwe = FeedListStatView()
    private let collectionView = IntrinsicSizeCollectionView(frame: .zero, collectionViewLayout: LogCollectionViewLayout())

    private var feedList: [Feed] = []
    
    @objc
    private func pullToRefresh() {
        listener?.action(.pullToRefresh)
    }
}

private extension FeedListView {
    func setup() {
        backgroundColor = UIColor(named: "color_logBackground")
        scrollView.do {
            $0.alwaysBounceVertical = true
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            $0.refreshControl = refreshControl
        }
        collectionView.do {
            $0.backgroundColor = .clear
            $0.isScrollEnabled = false
            $0.dataSource = self
            $0.delegate = self
            $0.register(LogCollectionViewCell.self, forCellWithReuseIdentifier: "LogCollectionViewCell")
        }
        addSubview(scrollView)
        [levelRankingView, statViwe, collectionView].forEach {
            scrollView.addArrangedSubview($0)
        }
    }
    
    func layout() {
        let frame = UIScreen.main.bounds
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        levelRankingView.snp.makeConstraints {
            $0.height.equalTo(frame.height * 0.36)
        }
        statViwe.snp.makeConstraints {
            $0.height.equalTo(182)
        }
    }
}

extension FeedListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LogCollectionViewCell", for: indexPath) as? LogCollectionViewCell,
              let feed = feedList[safe: indexPath.item]
        else { return .init() }
        cell.viewModel = .init(image: feed.photo)
        return cell
    }
}

extension FeedListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let feed = feedList[safe: indexPath.item] else { return }
        listener?.action(.feedSelected(feed))
    }
}
