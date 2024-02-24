//
//  ImageDownloadManager.swift
//  UniPlogger
//
//  Created by 손병근 on 2020/11/28.
//  Copyright © 2020 손병근. All rights reserved.
//

import UIKit

struct ImageDownloadManager {
    
    static let shared = ImageDownloadManager()
    private init() { }
    func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        let url = NetworkEnvironment.baseUrl.rawValue + url
        if let cachedImage = cache.object(forKey: NSString(string: url)) {
            completion(cachedImage)
        } else {
            SessionManager.shared.download(url).responseData { (response) in
                switch response.result {
                case .success(let data):
                    if let imageToCache = UIImage(data: data) {
                        self.cache.setObject(imageToCache, forKey: NSString(string: url))
                        DispatchQueue.main.async {
                            completion(imageToCache)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(thumbnailImage)
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        completion(thumbnailImage)
                    }
                }
            }
        }
    }
    
    private let cache = NSCache<NSString, UIImage>()
    private let thumbnailImage = UIImage(named: "thumbnail")
}
