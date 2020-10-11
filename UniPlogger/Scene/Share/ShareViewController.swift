//
//  ShareViewController.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/09/29.
//  Copyright (c) 2020 손병근. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Photos
import SnapKit
import Then

protocol ShareDisplayLogic: class {
    func displaySomething(viewModel: Share.Something.ViewModel)
    
}

class ShareViewController: UIViewController, ShareDisplayLogic {
    var interactor: ShareBusinessLogic?
    var router: (NSObjectProtocol & ShareRoutingLogic & ShareDataPassing)?
    
    lazy var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "mainBackground")
    }
    lazy var ploggingImageView = PloggingImageView().then {
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 10
    }
    lazy var dismissButton = UIButton().then {
        $0.setImage(UIImage(named: "share_dismiss"), for: .normal)
        $0.backgroundColor = UIColor(named: "dismissColor")
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(touchUpDismissButton), for: .touchUpInside)
    }
    lazy var shareButton = UIButton().then {
        $0.setImage(UIImage(named: "share_instagram"), for: .normal)
        $0.backgroundColor = UIColor(named: "shareColor")
        $0.layer.cornerRadius = 50
        $0.addTarget(self, action: #selector(touchUpShareButton), for: .touchUpInside)
    }

    // MARK: Object lifecycle
      
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = ShareInteractor()
        let presenter = SharePresenter()
        let router = ShareRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setUpView()
        setUpLayout()
    }

    func displaySomething(viewModel: Share.Something.ViewModel) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let view = touches.first?.view else { return }
        guard view == ploggingImageView else { return }
        imageViewTapped()
    }
    
    func imageViewTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.camera
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func touchUpDismissButton() {
        guard let imageForSave = ploggingImageView.image else { return }
        let photoManager = PhotoManager(albumName: "UniPlogger")
        photoManager.save(imageForSave) { (success, error) in
            if success {
                print("saved")
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    @objc func touchUpShareButton() {
        guard let imageForShare = ploggingImageView.image else { return }
        let photoManager = PhotoManager(albumName: "UniPlogger")
        photoManager.save(imageForShare) { (success, error) in
            if success {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                guard let lastAssetIdentifier = fetchResult.firstObject?.localIdentifier else { return }
                print(lastAssetIdentifier)
                self.interactor?.shareToInstagram(assetIdentifier: lastAssetIdentifier)
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

extension ShareViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ploggingImageView.image = info[.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
}
