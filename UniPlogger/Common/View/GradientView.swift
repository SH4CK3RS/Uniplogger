//
//  GradientView.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/09/30.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

final class GradientView: UIView {
    var colors: [UIColor] = []
    var locations: [Double] = []
    private var isHorizontal: Bool = false
    private var isDiagonal: Bool = false
    
    override static var layerClass: AnyClass { CAGradientLayer.self }
    
    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    private func updatePoints() {
        if isHorizontal{
            gradientLayer.startPoint = isDiagonal ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint = isDiagonal ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = isDiagonal ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint = isDiagonal ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    private func updateLocations() {
        gradientLayer.locations = locations.map { $0 as NSNumber }
    }
    
    private func updateColors() {
        gradientLayer.colors = colors.map { $0.cgColor }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupGradients()
    }
    
    private func setupGradients() {
        updatePoints()
        updateLocations()
        updateColors()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradients()
    }
}
