//
//  FeedListCollectionViewCell.swift
//  UniPlogger
//
//  Created by 손병근 on 10/22/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class FeedListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    func update(image: String) {
        ImageDownloadManager.shared.downloadImage(url: image) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Private
    
    private let imageView = UIImageView()
}

private extension FeedListCollectionViewCell {
    func setup() {
        contentView.backgroundColor = .clear
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
        contentView.addSubview(imageView)
    }
    
    func layout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
