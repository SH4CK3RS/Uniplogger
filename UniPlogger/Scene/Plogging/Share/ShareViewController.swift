//
//  ShareViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 10/8/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum SharePresentableListenerRequest {
    case viewDidLoad
    case dismissButtonTapped(UIImage?)
    case shareButtonTapped(UIImage)
    case dismiss
}

protocol SharePresentableListener: AnyObject {
    func request(_ request: SharePresentableListenerRequest)
}

final class ShareViewController: UIViewController, SharePresentable, ShareViewControllable {

    weak var listener: SharePresentableListener?
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listener?.request(.viewDidLoad)
    }
    
    private let mainView = ShareView()
    func request(_ request: SharePresenterRequest) {
        switch request {
        case let .showUploadedFeed(feed):
            mainView.showUploadedFeed(feed)
        case .showSuccessAlert:
            showAlert(title: "사진 저장", message: "사진이 저장되었습니다.")
        case .showErrorAlert:
            showAlert(title: "ERROR", message: "사진을 저장하는 도중 문제가 발생했습니다.")
        }
    }
    
    func showAlert(title: String,
                   message: String,
                   confirm: (title: String, handler: (() -> Void)?)? = nil,
                   cancel: (title: String, handler: (() -> Void)?)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let confirm {
            alertController.addAction(.init(
                title: confirm.title,
                style: .default) { _ in
                    confirm.handler?()
                })
        }
        if let cancel {
            alertController.addAction(.init(
                title: cancel.title,
                style: .cancel) { _ in
                 cancel.handler?()
            })
        }
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ShareViewController: ShareViewListener {
    func action(_ action: ShareViewAction) {
        switch action {
        case let .dismissButtonTapped(mergedImage):
            if AuthManager.shared.autoSave {
                listener?.request(.dismissButtonTapped(mergedImage))
            } else {
//                showAlert(title: "사진을 저장하시겠습니까?",
//                          message: "사진을 자동으로 저장하시려면 환경설정을 확인해주세요.",
//                          confirm: (title: "YES", handler: { [weak self] _ in
//                    self?.listener?.request(.dismissButtonTapped(mergedImage))
//                }),
//                          cancel: (title: "NO", handler: { [weak self] _ in
//                    self?.listener?.request(.dismissButtonTapped(nil))
//                }))
            }
            
        case let .shareButtonTapped(mergedImage):
            listener?.request(.shareButtonTapped(mergedImage))
        }
    }
}
