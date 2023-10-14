//
//  PloggingRootInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 2023/09/24.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum PloggingRootRouterRequest {
    case routeToPloggingMain
    case routeToStartCounting
    case detachStartCounting
    case routeToPloggingRecord
    case routeToCamera
    case routeToImagePreview(UIImage)
    case detachImagePreview
    case routeToShare(Feed)
    case finishPlogging
}

protocol PloggingRootRouting: ViewableRouting {
    func request(_ request: PloggingRootRouterRequest)
}

protocol PloggingRootPresentable: Presentable {
    var listener: PloggingRootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol PloggingRootListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PloggingRootInteractor: PresentableInteractor<PloggingRootPresentable>, PloggingRootInteractable, PloggingRootPresentableListener {

    weak var router: PloggingRootRouting?
    weak var listener: PloggingRootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: PloggingRootPresentable,
         stream: PloggingMutableStream,
         service: PloggingRootServiceable) {
        self.stream = stream
        self.service = service
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.request(.routeToPloggingMain)
    }

    private let service: PloggingRootServiceable
    private let stream: PloggingMutableStream
    private var data = PloggingData()
}

// MARK: - PloggingMainListenerRequest
extension PloggingRootInteractor {
    func request(_ request: PloggingMainListenerRequest) {
        switch request {
        case .startButtonTapped:
            router?.request(.routeToStartCounting)
        case let .stopButtonTapped(distance, time):
            data.distance = distance
            data.time = time
            router?.request(.routeToPloggingRecord)
        }
        
    }
}

// MARK: - StartCountingListenerRequest
extension PloggingRootInteractor {
    func request(_ request: StartCountingListenerRequest) {
        switch request {
        case .countDidEnd:
            router?.request(.detachStartCounting)
            stream.updateCountingFinished()
        }
    }
}

// MARK: - PloggingRecordListenerRequest
extension PloggingRootInteractor {
    func request(_ request: PloggingRecordListenerRequest) {
        switch request {
        case let .takePhoto(items):
            data.items = items
            router?.request(.routeToCamera)
        }
    }
}

// MARK: - CameraListenerRequest
extension PloggingRootInteractor {
    func request(_ request: CameraListenerRequest) {
        switch request {
        case let .didTakePhoto(photo):
            data.image = photo
            router?.request(.routeToImagePreview(photo))
        }
    }
}

// MARK: - ImagePreviewListenerRequest
extension PloggingRootInteractor {
    func request(_ request: ImagePreviewListenerRequest) {
        switch request {
        case .back:
            data.image = nil
            router?.request(.detachImagePreview)
        case .next:
            service.uploadPloggingRecord(data: data)
                .observe(on: MainScheduler.instance)
                .subscribe(with: self) { owner, feed in
                    owner.router?.request(.routeToShare(feed))
                } onFailure: { owner, error in
                    
                }.disposeOnDeactivate(interactor: self)
        }
    }
}

extension PloggingRootInteractor {
    func request(_ request: ShareListenerRequest) {
        switch request {
        case .dismiss:
            router?.request(.finishPlogging)
        }
    }
}
