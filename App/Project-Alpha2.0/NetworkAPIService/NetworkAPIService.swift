//
//  NetworkAPIService.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkAPIService {        
    
    // MARK: - Fetch Collection Photos
    
    func fetchCollectionData(pageNumber: Int, username: String?, collectionType: CollectionRequestType, completioHandler: @escaping (_ response: [Collection]?, _ error: Error?) -> Void) {
        
        var urlString = "https://api.unsplash.com"
        
        switch collectionType {
        case .allCollection:
            urlString = urlString + "/collections"
        case .userCollection:
            if let uname = username {
                urlString = urlString + "/users/" + uname + "/collections"
            }
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let params = [
            "client_id": Keys.clientID,
            "page": pageNumber.description,
            "per_page": "20"
        ]
        
        let request = Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.init(destination: .queryString))
        
        request.validate(statusCode: 200..<300)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let data = JSON(value)
                var array = [Collection]()
                if let list = data.array {
                    list.forEach({ (collect) in
                        array.append(Collection(json: collect))
                    })
                }
                completioHandler(array, nil)
            case .failure(let error):
                completioHandler(nil, error)
            }
        }
        
    }
    
    // MARK: - Fetch Photo Datas
    
    func fetchPhotoData(pageNumber: Int, photoType: PhotoRequestType, photoId: Int?, username: String?, query: String?, completionHandler: @escaping (_ response: [Photo]?, _ error: Error?) -> Void) {
        
        var urlString = "https://api.unsplash.com"
        var params = [
            "client_id": Keys.clientID,
            "page": pageNumber.description,
            "per_page": "20"
        ]
        
        switch photoType {
        case .allPhoto:
            urlString = urlString + "" + "/photos/"
        case .collectionPhoto:
            if let id = photoId {
                urlString = urlString + "/collections/" + id.description + "/photos"
            }
        case .likesPhoto:
            if let uname = username {
                urlString = urlString + "/users/" + uname + "/likes"
            }
        case .userPhoto:
            if let uname = username {
                urlString = urlString + "/users/" + uname + "/photos"
            }
        case .searchPhoto:
            if let searchWord = query {
                urlString = urlString + "" + "/search/photos"
                params.updateValue(searchWord, forKey: "query")
            }
        }
                
        guard let url = URL(string: urlString) else { return }
        
        let request = Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.init(destination: .queryString))
        
        request.validate(statusCode: 200..<300)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                var data = JSON(value)
                var array = [Photo]()
                if photoType == .searchPhoto {
                    data = data["results"]
                }
                if let list = data.array {
                    list.forEach({ (photo) in
                        array.append(Photo(json: photo))
                    })
                }
                
                completionHandler(array, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
        
    }
    
    // MARK: - Fetch Random Photo Data
    
    func fetchRandomPhotoData(completionHandler: @escaping (_ response: Photo?, _ error: Error?) -> Void) {
        
        let urlString = "https://api.unsplash.com/photos/random"
        let params = [
            "client_id": Keys.clientID
        ]
        guard let url = URL(string: urlString) else { return }
        
        let request = Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.init(destination: .queryString))
        
        request.validate(statusCode: 200..<300)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let data = JSON(value)
                let photo = Photo(json: data)
                completionHandler(photo, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    // MARK: - Fetch Photo Details Data
    
    func fetchPhotoDetailData(photoId: String, completionHandler: @escaping (_ response: Photo?, _ error: Error?) -> Void) {
        
        let urlString = "https://api.unsplash.com/photos/" + photoId
        let params = [
            "client_id": Keys.clientID
        ]
        
        guard let url = URL(string: urlString) else { return }
        
        let request = Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.init(destination: .queryString))                
        
        request.validate(statusCode: 200..<300)
        request.responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let data = JSON(value)
                let photo = Photo(json: data)
                
                completionHandler(photo, nil)
            case .failure(let error):
                completionHandler(nil, error)
                
            }
        }
        
    }
    
}

