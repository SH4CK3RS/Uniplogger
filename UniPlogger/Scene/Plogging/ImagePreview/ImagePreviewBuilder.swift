//
//  ImagePreviewBuilder.swift
//  UniPlogger
//
//  Created by 손병근 on 10/2/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol ImagePreviewDependency: Dependency {}
final class ImagePreviewComponent: Component<ImagePreviewDependency> {
    fileprivate let image: UIImage
    
    init(dependency: ImagePreviewDependency,
         image: UIImage) {
        self.image = image
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol ImagePreviewBuildable: Buildable {
    func build(withListener listener: ImagePreviewListener,
               image: UIImage) -> ImagePreviewRouting
}

final class ImagePreviewBuilder: Builder<ImagePreviewDependency>, ImagePreviewBuildable {

    override init(dependency: ImagePreviewDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ImagePreviewListener,
               image: UIImage) -> ImagePreviewRouting {
        let component = ImagePreviewComponent(dependency: dependency, image: image)
        let viewController = ImagePreviewViewController()
        let interactor = ImagePreviewInteractor(presenter: viewController,
                                                image: component.image)
        interactor.listener = listener
        return ImagePreviewRouter(interactor: interactor, viewController: viewController)
    }
}
