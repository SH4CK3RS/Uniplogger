//
//  LogCollectionViewLayout.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/22.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

final class LogCollectionViewLayout: UICollectionViewFlowLayout {
    
    // MARK: - Constants
    private struct Constants {
        static let numberOfColumns = 3
        static let cellPadding: CGFloat = 11
    }
    
    // MARK: - Properties
    private var cache = [UICollectionViewLayoutAttributes]()
    private var xOffset = [CGFloat]()
    private var yOffset = [CGFloat](repeating: 0, count: Constants.numberOfColumns)
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // MARK: - Initializers
    override init() {
        super.init()
        self.scrollDirection = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }
        setupColumns(for: collectionView)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[safe: indexPath.item] ?? createAttributesForItem(at: indexPath)
    }
    
    // MARK: - Helper Methods
    private func setupColumns(for collectionView: UICollectionView) {
        let columnWidth = contentWidth / CGFloat(Constants.numberOfColumns)
        xOffset = (0..<Constants.numberOfColumns).map { CGFloat($0) * columnWidth }
        
        var column = 0
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = createAttributesForItem(at: indexPath)
            cache.append(attributes)
            
            contentHeight = max(contentHeight, attributes.frame.maxY)
            yOffset[column] = yOffset[column] + attributes.frame.height
            column = column < (Constants.numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    private func createAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let columnWidth = contentWidth / CGFloat(Constants.numberOfColumns)
        let column = indexPath.item % Constants.numberOfColumns
        
        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: columnWidth)
        let insetFrame = frame.insetBy(dx: Constants.cellPadding, dy: Constants.cellPadding)
        
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = insetFrame
        
        return attributes
    }
    
    // MARK: - Public Methods
    func resetCache() {
        cache.removeAll()
        xOffset.removeAll()
        yOffset = [CGFloat](repeating: 0, count: Constants.numberOfColumns)
    }
}
