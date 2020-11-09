//
//  AuthorVM.swift
//  Project-Alpha2.0
//
//  Created by Мадияр on 8/1/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AuthorVM {
    
    weak var delegate: AuthorVMDelegate?
    let networkService = NetworkAPIService()
    
    var photos: [Photo] = []
    var likes: [Photo] = []
    
    var collections: [Collection] = []
    var current: [Photo] = []
    
    var avatarImage: UIImage = UIImage()
    
    func getAvatar(_ author: SponsorAndUser?) {
        guard let path = author?.profileImage.medium else { return }
        guard let url = URL(string: path) else { return }
        
        Alamofire.request(url).responseImage { (response) in
            switch response.result {
            case .success(let value):
                self.avatarImage = value
                self.delegate?.setAvatarImage()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUserPhotosData(type: PhotoRequestType, pageNumber: Int, username: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        
        networkService.fetchPhotoData(pageNumber: pageNumber, photoType: type, photoId: nil, username: username, query: nil) { [weak self] (response, error) in
            if let unwrappedError = error {
                completionHandler(unwrappedError)
            } else if let data = response {
                if type == .likesPhoto {
                    self?.likes = data
                } else if type == .userPhoto {
                    self?.photos = data
                }
            }
            completionHandler(nil)
        }
        
    }
    
    func fetchUserCollectionData(type: CollectionRequestType, pageNumber: Int, username: String, completionHandler: @escaping (_ error: Error?) -> Void) {
        
        networkService.fetchCollectionData(pageNumber: pageNumber, username: username, collectionType: type) { [weak self] (response, error) in
            if let unwrappedError = error {
                completionHandler(unwrappedError)
            } else if let data = response {
                self?.collections = data
            }
            completionHandler(nil)
        }
        
    }
    
    func getCountOfPhotos() -> Int {
        return current.count
    }
    
    func getCountOfCollection() -> Int {
        return collections.count
    }
    
    func getDataOfCollection() -> [Collection] {
        
        return collections
    }
    
    func getDataOfPhotos(at index: Int) -> (String, String) {
        
        var buttonTitle = current[index].user.name
        if current[index].sponsorship.id != "" {
            if current[index].sponsorship.name != "" {
                if current[index].sponsorship.name != current[index].user.name {
                    buttonTitle = buttonTitle + " \n" + "Sponsored by" + " " + current[index].sponsorship.name
                } else {
                    buttonTitle = buttonTitle + " \n" + "Sponsored"
                }
            }
        }
        
        return (current[index].urls.regular, buttonTitle)
    }
    
    func getSizeOfPhoto(at index: Int) -> CGFloat {
        
        return CGFloat.init(current[index].height / current[index].width) * UIScreen.main.bounds.width
    }
    
}
