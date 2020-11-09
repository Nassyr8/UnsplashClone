//
//  CollectionPhotosVM.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/30/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit

class CollectionPhotosVM {
    
    // MARK: - Public Properties
    
    var photos: [Photo] = []
    var networkService = NetworkAPIService()
    weak var updateDataDelegate: UpdateDataDelegate?
    var isLoading = false
    var pageNumber = 1
    
    // MARK: - Public Methods
    
    func getAuthorInfo(at index: Int) -> SponsorAndUser {
        
        return photos[index].user
    }
    
    func getCountOfPhotos() -> Int {
        
        return photos.count
    }
    
    func getDataOfPhotos(at index: Int) -> (String, String, String) {
        
        var buttonTitle = photos[index].user.name
        if photos[index].sponsorship.id != "" {
            if photos[index].sponsorship.name != "" {
                if photos[index].sponsorship.name != photos[index].user.name {
                    buttonTitle = buttonTitle + " \n" + "Sponsored by" + " " + photos[index].sponsorship.name
                } else {
                    buttonTitle = buttonTitle + " \n" + "Sponsored"
                }
            }
        }
        return (photos[index].urls.regular, buttonTitle, photos[index].color)
    }
    
    func getSizeOfPhoto(at index: Int) -> CGFloat {
        
        return CGFloat.init(photos[index].height / 10)
    }    
    
    func getPhotos(pageNumber: Int, id: Int?, photoType: PhotoRequestType, query: String?, completionHandler: @escaping (_ isEmpty: Bool, _ error: Error?) -> Void) {
        
        networkService.fetchPhotoData(pageNumber: pageNumber, photoType: photoType, photoId: id, username: nil, query: query) { [weak self] (response, error) in
            if let unwrappedError = error {
                
                completionHandler(false, unwrappedError)
            } else if let data = response {
                self?.photos = data
                var isEmp = Bool()
                isEmp = data.count == 0 ? true : false
                self?.updateDataDelegate?.updateData()
                
                completionHandler(isEmp, nil)
            }
        }
    }
    
    func loadMorePhotos(offset: Int, photoType: PhotoRequestType, photoId: Int?, query: String?, completionHandler: @escaping (_ response: [Photo]?, _ error: Error?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            if offset != 0 {
                sleep(2)
            }
            
            DispatchQueue.main.async(execute: {
                self.pageNumber += 1
                
                self.networkService.fetchPhotoData(pageNumber: self.pageNumber, photoType: photoType, photoId: photoId, username: nil, query: query, completionHandler: { (response, error) in
                    if let unwrappedError = error {
                        completionHandler(nil, unwrappedError)
                    } else if let data = response {
                        completionHandler(data, nil)
                    }
                    
                })
                
            })
            
        }
        
    }
    
}
