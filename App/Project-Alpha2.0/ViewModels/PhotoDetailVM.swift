//
//  PhotoDetailVM.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/2/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PhotoDetailVM {
    
    let normalTimeConstant = 0.4
    let fastTimeConstant = 0.2
    let height = UIScreen.main.bounds.height
    let networkService = NetworkAPIService()
    
    var isShow: Bool = false
    var isHidden: Bool = false
    var touchPosition: CGPoint!
    var photoDetailData: Photo?
    
    func fetchPhotoDetailData(id: String, completionHandler: @escaping (_ response: Photo?, _ error: Error?) -> Void) {
        
        networkService.fetchPhotoDetailData(photoId: id) { (response, error) in
            
            if let unwrappedError = error {
                completionHandler(nil, unwrappedError)
            } else if let data = response {
                self.photoDetailData = data
                completionHandler(data, nil)
            }
            
        }
        
    }
    
}
