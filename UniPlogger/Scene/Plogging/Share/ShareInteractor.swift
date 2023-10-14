//
//  ShareInteractor.swift
//  UniPlogger
//
//  Created by 손병근 on 10/8/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ShareRouting: ViewableRouting {
    
}

enum SharePresenterRequest {
    case showUploadedFeed(Feed)
    case showSuccessAlert
    case showErrorAlert
}

protocol SharePresentable: Presentable {
    var listener: SharePresentableListener? { get set }
    func request(_ request: SharePresenterRequest)
}

enum ShareListenerRequest {
    case dismiss
}
protocol ShareListener: AnyObject {
    func request(_ request: ShareListenerRequest)
}

final class ShareInteractor: PresentableInteractor<SharePresentable>, ShareInteractable, SharePresentableListener {
    
    weak var router: ShareRouting?
    weak var listener: ShareListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: SharePresentable,
         feed: Feed) {
        self.feed = feed
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
    }
    
    override func willResignActive() {
        super.willResignActive()
        
    }
    
    func request(_ request: SharePresentableListenerRequest) {
        switch request {
        case .viewDidLoad:
            presenter.request(.showUploadedFeed(feed))
        case let .dismissButtonTapped(mergedImage):
            if let mergedImage {
                saveImage(mergedImage)
            } else {
                listener?.request(.dismiss)
            }
        case let .shareButtonTapped(mergedImage):
            saveImageAndShare(mergedImage)
        case .dismiss:
            listener?.request(.dismiss)
        }
    }
    
    private func saveImage(_ image: UIImage) {
        PhotoManager.shared.save(image) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.presenter.request(.showSuccessAlert)
                }
            } else {
                DispatchQueue.main.async {
                    self?.presenter.request(.showErrorAlert)
                }
            }
        }
    }
    
    private func saveImageAndShare(_ image: UIImage) {
        PhotoManager.shared.save(image) { [weak self] success in
            if success,
               let identifier = PhotoManager.shared.getImageIdentifier(),
               let url = URL(string: "instagram://library?LocalIdentifier=\(identifier)") {
                DispatchQueue.main.async {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    } else {
                        print("Instagram is not installed")
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.presenter.request(.showErrorAlert)
                }
            }
        }
    }
    
    private let feed: Feed
}
