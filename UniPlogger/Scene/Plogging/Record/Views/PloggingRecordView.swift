//
//  PloggingRecordView.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

enum PloggingRecordViewAction {
    case skipButtonTapped
    case nextButtonTapped([PloggingItemType])
    case ploggingItemSelected(PloggingItemType)
}

protocol PloggingRecordViewListener: AnyObject {
    func action(_ action: PloggingRecordViewAction)
}

final class PloggingRecordView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
        layout()
        setButtonEnabled(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    weak var listener: PloggingRecordViewListener?
    
    // MARK: - Private
    private var selectedItems: [Int] = []
    
    private let scrollView = ScrollStackView()
    private let skipButtonContainer = UIView()
    private let skipButton = UIButton()
    private let titleContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let collectionViewContainer = UIView()
    private let collectionView = IntrinsicSizeCollectionView(frame: .zero, collectionViewLayout: PloggingRecordCollectionViewLayout())
    private let nextButtonContainer = UIView()
    private let nextButtonView = UIView()
    private let nextLabel = UILabel()
    private let nextImageView = UIImageView()
    private let nextButton = UIButton()
    
    @objc
    private func skipButtonTapped() {
        selectedItems = []
        collectionView.reloadData()
        listener?.action(.skipButtonTapped)
    }
    
    @objc
    private func nextButtonTapped() {
        let items = selectedItems.map { PloggingItemType.allCases[$0] }
        listener?.action(.nextButtonTapped(items))
    }
    
    @objc
    private func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        guard gesture.state == .ended else { return }
        let p = gesture.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: p),
           let item = PloggingItemType.allCases[safe: indexPath.item] {
            listener?.action(.ploggingItemSelected(item))
        }
    }
    
    private func setButtonEnabled(_ isEnabled: Bool) {
        nextButtonView.backgroundColor = isEnabled ? .buttonEnabled : .clear
        nextButtonView.layer.borderColor = isEnabled ? UIColor.clear.cgColor : UIColor(hexString: "#999999").cgColor
        nextButtonView.layer.borderWidth = isEnabled ? 0 : 0.5
        nextButton.isEnabled = isEnabled
        nextLabel.textColor = .text
        nextImageView.tintColor = .text
    }
}

private extension PloggingRecordView {
    func setup() {
        skipButton.do {
            $0.setAttributedTitle(UPStyle().font(.roboto(ofSize: 15, weight: .bold)).color(UIColor(hexString: "#999999")).kern(1.25).apply(to: "SKIP"), for: .normal)
            $0.titleLabel?.font = .roboto(ofSize: 15, weight: .bold)
            $0.setTitleColor(.init(red: 196, green: 196, blue: 196), for: .normal)
            $0.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        }
        titleLabel.do {
            $0.text = "오늘 어떤 쓰레기를 주우셨나요?"
            $0.font = .notoSans(ofSize: 16, weight: .bold)
            $0.textAlignment = .center
        }
        subtitleLabel.do {
            $0.text = "버튼을 길게 눌러 세부 리스트를 확인할 수 있습니다."
            $0.font = .notoSans(ofSize: 12, weight: .regular)
            $0.textAlignment = .center
        }
        collectionView.do {
            $0.backgroundColor = .clear
            $0.dataSource = self
            $0.delegate = self
            $0.allowsMultipleSelection = true
            $0.register(PloggingRecordCollectionViewCell.self, forCellWithReuseIdentifier: "PloggingRecordCollectionViewCell")
        }
        nextButtonView.do {
            $0.backgroundColor = .buttonEnabled
            $0.layer.cornerRadius = 26
            $0.layer.masksToBounds = true
        }
        nextLabel.do {
            $0.text = "NEXT"
            $0.textColor = UIColor(hexString: "#999999")
            $0.font = .roboto(ofSize: 15, weight: .bold)
        }
        nextImageView.do {
            $0.contentMode = .center
            $0.image = UIImage(named: "ic_BtnNextRight")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = UIColor(hexString: "#999999")
        }
        nextButton.do {
            $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside
            )
        }
        
        addSubview(scrollView)
        scrollView.addArrangedSubview(skipButtonContainer)
        skipButtonContainer.addSubview(skipButton)
        scrollView.addArrangedSubview(titleContainer)
        titleContainer.addSubview(titleLabel)
        titleContainer.addSubview(subtitleLabel)
        scrollView.addArrangedSubview(collectionViewContainer)
        collectionViewContainer.addSubview(collectionView)
        scrollView.addArrangedSubview(nextButtonContainer)
        nextButtonContainer.addSubview(nextButtonView)
        nextButtonView.addSubview(nextLabel)
        nextButtonView.addSubview(nextImageView)
        nextButtonView.addSubview(nextButton)
    }
    
    func layout() {
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        skipButton.snp.makeConstraints {
            $0.top.equalTo(28)
            $0.trailing.equalTo(-27)
            $0.bottom.equalTo(-4)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(8)
            $0.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-28)
        }
        collectionView.snp.makeConstraints {
            $0.leading.equalTo(26)
            $0.trailing.equalTo(-26)
            $0.top.bottom.equalToSuperview()
        }
        nextButtonView.snp.makeConstraints {
            $0.top.equalTo(62)
            $0.trailing.equalTo(-32)
            $0.bottom.equalTo(-60)
            $0.width.equalTo(134)
            $0.height.equalTo(52)
        }
        nextImageView.snp.makeConstraints {
            $0.trailing.equalTo(-30)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
        nextLabel.snp.makeConstraints {
            $0.trailing.equalTo(nextImageView.snp.leading).offset(-8)
            $0.centerY.equalToSuperview().offset(0.5)
        }
        nextButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension PloggingRecordView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return PloggingItemType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "PloggingRecordCollectionViewCell", for: indexPath) as? PloggingRecordCollectionViewCell,
              let item = PloggingItemType.allCases[safe: indexPath.item] else { return .init() }
        
        let isSelected = selectedItems.contains(indexPath.item)
        cell.viewModel = .init(title: item.description, isSelected: isSelected)
        let gesture =  UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        cell.addGestureRecognizer(gesture)
        return cell
    }
}

extension PloggingRecordView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedItems.firstIndex(of: indexPath.item) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(indexPath.item)
        }
        
        if selectedItems.isEmpty {
            setButtonEnabled(false)
        } else {
            setButtonEnabled(true)
        }
        collectionView.reloadData()
    }
}
