//
//  PloggingRecordViewController.swift
//  UniPlogger
//
//  Created by 손병근 on 9/30/23.
//  Copyright © 2023 손병근. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

enum PloggingRecordPresentableListenerRequest {
    case takePicture
}

protocol PloggingRecordPresentableListener: AnyObject {
    func request(_ request: PloggingRecordPresentableListenerRequest)
}

final class PloggingRecordViewController: UIViewController, PloggingRecordPresentable, PloggingRecordViewControllable {

    private var capturedImage: UIImage?
    override func loadView() {
        view = mainView
        mainView.listener = self
    }
    
    // MARK: - Internal
    weak var listener: PloggingRecordPresentableListener?
    // MARK: - Private
    private let mainView = PloggingRecordView()
}

extension PloggingRecordViewController: PloggingRecordViewListener {
    func action(_ action: PloggingRecordViewAction) {
        switch action {
        case .skipButtonTapped, .nextButtonTapped:
            let alert = UIAlertController(title: "플로깅 인증 사진을\n촬영하시겠습니까?", message: "사진 촬영을 위해 사진앱을 실행합니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "실행", style: .default) { [weak self] (_) in
                self?.listener?.request(.takePicture)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        case let .ploggingItemSelected(itemType):
            let detailView = TrashDetailPopupView(type: itemType)
            detailView.modalTransitionStyle = .crossDissolve
            detailView.modalPresentationStyle = .overFullScreen
            self.present(detailView, animated: true, completion: nil)
        }
    }
}
