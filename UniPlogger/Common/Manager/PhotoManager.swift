//
//  PhotoManager.swift
//  UniPlogger
//
//  Created by 바보세림이 on 2020/10/01.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit
import Photos

final class PhotoManager {
    static let shared = PhotoManager(albumName: "UniPlogger")
    private init(albumName: String) {
        self.albumName = albumName
    }
    
    // MARK: Internal
    func save(_ image: UIImage, completion: @escaping (Bool) -> ()) {
        guard isAuthorized else {
            nextAction = {
                self.save(image, completion: completion)
            }
            checkAuthorization()
            return
        }
        getAlbum { album in
            guard let album else {
                completion(false)
                return
            }
            self.add(image: image, album: album) { result in
                completion(result)
            }
        }
    }
    
    func getImageIdentifier() -> String? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        return fetchResult.firstObject?.localIdentifier
    }
    
    // MARK: Private
    private let albumName: String
    private var album: PHAssetCollection?
    private var isAuthorized: Bool {
        guard case .authorized = PHPhotoLibrary.authorizationStatus(for: .readWrite) else {
            return false
        }
        return true
    }
    private var nextAction: (() -> Void)?

    private func getAlbum(completion: @escaping ((PHAssetCollection?) -> Void)) {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if let album = collection.firstObject {
            completion(album)
        } else {
            createAlbum { result in
                if result {
                    self.getAlbum(completion: completion)
                } else {
                    completion(nil)
                }
            }
        }
    }

    private func createAlbum(completion: @escaping ((Bool) -> Void)) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
        }, completionHandler: { (result, error) in
            completion(result)
        })
    }

    private func add(image: UIImage, album: PHAssetCollection, completion: @escaping (Bool) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if let placeholder = assetChangeRequest.placeholderForCreatedAsset {
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
                let enumeration = NSArray(object: placeholder)
                albumChangeRequest?.addAssets(enumeration)
            }
        }, completionHandler: { (result, _) in
            completion(result)
        })
    }
    
    
    
    private func goToSetting() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func checkAuthorization() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            nextAction?()
            nextAction = nil
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                guard status == .authorized else {
                    self.checkAuthorization()
                    return
                }
                self.nextAction?()
                self.nextAction = nil
            }
        case .denied:
            // TODO: 세팅 변경 시 활동 데이터가 모두 날아가므로 해당 데이터 세이빙 필요
            goToSetting()
        default: break
        }
    }
}
