//
//  PloggingRootRouter.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import UIKit

protocol PloggingRootInteractable: Interactable,
                                   PloggingMainListener,
                                   StartCountingListener,
                                   PloggingRecordListener,
                                   CameraListener,
                                   ImagePreviewListener,
                                   ShareListener {
    var router: PloggingRootRouting? { get set }
    var listener: PloggingRootListener? { get set }
}

protocol PloggingRootViewControllable: ViewControllable {
    func set(viewControllers: [ViewControllable], animated: Bool)
    func push(viewController: ViewControllable, animated: Bool)
    func present(_ viewController: ViewControllable, animated: Bool)
    func dismiss(_ viewController: ViewControllable, animated: Bool)
}

final class PloggingRootRouter: BaseViewableRouter<PloggingRootInteractable, PloggingRootViewControllable>, PloggingRootRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: PloggingRootInteractable,
         viewController: PloggingRootViewControllable,
         ploggingMainBuilder: PloggingMainBuildable,
         startCountingBuilder: StartCountingBuildable,
         ploggingRecordBuilder: PloggingRecordBuildable,
         cameraBuilder: CameraBuilder,
         imagePreviewBuilder: ImagePreviewBuildable,
         shareBuilder: ShareBuildable) {
        self.ploggingMainBuilder = ploggingMainBuilder
        self.startCountingBuilder = startCountingBuilder
        self.ploggingRecordBuilder = ploggingRecordBuilder
        self.cameraBuilder = cameraBuilder
        self.imagePreviewBuilder = imagePreviewBuilder
        self.shareBuilder = shareBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func request(_ request: PloggingRootRouterRequest) {
        switch request {
        case .routeToPloggingMain:
            routeToPloggingMain()
        case .routeToStartCounting:
            routeToStartCounting()
        case .detachStartCounting:
            detachStartCounting()
        case .routeToPloggingRecord:
            routeToPloggingRecord()
        case .routeToCamera:
            routeToCamera()
        case let .routeToImagePreview(photo):
            routeToImagePreview(photo)
        case .detachImagePreview:
            break
        case let .routeToShare(feed):
            routeToShare(feed)
        case .finishPlogging:
            finishPlogging()
        }
    }
    
    private let ploggingMainBuilder: PloggingMainBuildable
    private var ploggingMainRouter: PloggingMainRouting?
    
    private let startCountingBuilder: StartCountingBuildable
    private var startCountingRouter: StartCountingRouting?
    
    private let ploggingRecordBuilder: PloggingRecordBuildable
    private var ploggingRecordRouter: PloggingRecordRouting?
    
    private let cameraBuilder: CameraBuildable
    private var cameraRouter: CameraRouting?
    
    private let imagePreviewBuilder: ImagePreviewBuildable
    private var imagePreviewRouter: ImagePreviewRouting?
    
    private let shareBuilder: ShareBuildable
    private var shareRouter: ShareRouting?
    
    private func routeToPloggingMain() {
        let router = ploggingMainBuilder.build(withListener: interactor)
        ploggingMainRouter = router
        attachChild(router)
        viewController.set(viewControllers: [router.viewControllable], animated: false)
    }
    
    private func routeToStartCounting() {
        let router = startCountingBuilder.build(withListener: interactor)
        startCountingRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.modalPresentationStyle = .overFullScreen
        router.viewControllable.uiviewController.modalTransitionStyle = .crossDissolve
        viewController.present(router.viewControllable, animated: false)
    }
    
    private func detachStartCounting() {
        guard let router = startCountingRouter else { return }
        startCountingRouter = nil
        detachChild(router)
        viewController.dismiss(router.viewControllable, animated: true)
    }
    
    private func routeToPloggingRecord() {
        let router = ploggingRecordBuilder.build(withListener: interactor)
        ploggingRecordRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.hidesBottomBarWhenPushed = true
        viewController.push(viewController: router.viewControllable, animated: false)
    }
    
    private func routeToCamera() {
        let router = cameraBuilder.build(withListener: interactor)
        cameraRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.hidesBottomBarWhenPushed = true
        viewController.push(viewController: router.viewControllable, animated: false)
    }
    
    private func routeToImagePreview(_ image: UIImage) {
        let router = imagePreviewBuilder.build(withListener: interactor, image: image)
        imagePreviewRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.hidesBottomBarWhenPushed = true
        viewController.push(viewController: router.viewControllable, animated: false)
    }
    
    private func routeToShare(_ feed: Feed) {
        let router = shareBuilder.build(withListener: interactor, feed: feed)
        shareRouter = router
        attachChild(router)
        router.viewControllable.uiviewController.hidesBottomBarWhenPushed = true
        viewController.push(viewController: router.viewControllable, animated: true)
    }
    
    private func finishPlogging() {
        guard let ploggingMainRouter,
              let ploggingRecordRouter,
              let cameraRouter,
              let imagePreviewRouter,
              let shareRouter
        else { return }
        [ploggingRecordRouter, cameraRouter, imagePreviewRouter, shareRouter].forEach {
            detachChild($0)
        }
        self.ploggingRecordRouter = nil
        self.cameraRouter = nil
        self.imagePreviewRouter = nil
        self.shareRouter = nil
        
        viewController.set(viewControllers: [ploggingMainRouter.viewControllable], animated: true)
    }
}
