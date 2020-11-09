//
//  ImageCache.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/4/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    
    let imageCache = AutoPurgingImageCache()
    
    private init(){}
    
    func addImage(image: UIImage, with identifiter: String) {
        imageCache.add(image, withIdentifier: identifiter)
    }
    
    func fetchImage(with identifiter: String) -> UIImage {
        return imageCache.image(withIdentifier: identifiter) ?? UIImage()
    }
}
