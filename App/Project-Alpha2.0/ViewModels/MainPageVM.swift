//
//  MainPageVM.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import Foundation

import UIKit

class MainPageVM {
    
    // MARK: - Public Properties
    
    var sectionTitles = ["Explore", "New"]
    var collections: [Collection] = []
    var photos: [Photo] = []
    var networkService = NetworkAPIService()
    weak var updateDataDelegate: UpdateDataDelegate?
    var isLoading = false
    var collectionsIsLoading = false
    var collectionsPageNumber = 1
    var pageNumber = 1
    
    // MARK: - Public Methods
    
    func getCountOfSectionTitles() -> Int {
        
        return sectionTitles.count
    }
    
    func getTitleOfSections(at index: Int) -> String {
        
        return sectionTitles[index]
    }
    
    func getCountOfCollections() -> Int {
        
        return collections.count
    }
    
    func getCountOfPhotos() -> Int {
        
        return photos.count
    }
    
    func getPhoto(at index: Int) -> Photo {
        
        return photos[index]
    }
    
    func getAuthorInfo(at index: Int) -> SponsorAndUser {
        
        return photos[index].user
    }
    
    func getDataOfCollections(at index: Int) -> (String, String) {
        
        return (collections[index].title, collections[index].coverPhoto.urls.regular)
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
        
        return CGFloat.init(photos[index].height / photos[index].width) * UIScreen.main.bounds.width
    }
    
    func getAllCollections() -> [Collection] {
        
        return collections
    }    
    
    func  getCollections(pageNumber: Int, completionHandler: @escaping (_ error: Error?) -> Void) {
        
        networkService.fetchCollectionData(pageNumber: pageNumber, username: nil, collectionType: .allCollection) { [weak self] (response, error) in
            if let unwrappedError = error {
                completionHandler(unwrappedError)
            } else if let data = response {
                self?.collections = data
                self?.updateDataDelegate?.updateData()
                completionHandler(nil)
            }
        }
        
    }
    
    func getPhotos(pageNumber: Int, completionHandler: @escaping (_ error: Error?) -> Void) {
        
        networkService.fetchPhotoData(pageNumber: pageNumber, photoType: .allPhoto, photoId: nil, username: nil, query: nil) { [weak self] (response, error) in
            if let unwrappedError = error {
                
                completionHandler(unwrappedError)
            } else if let data = response {
                
                self?.photos = data
                self?.pageNumber += 1
                self?.updateDataDelegate?.updateData()
                completionHandler(nil)
            }
        }
        
    }
    
    func getRandomPhotoData(completionHandler: @escaping (_ response: Photo?, _ error: Error?) -> Void) {
        
        networkService.fetchRandomPhotoData { (response, error) in
            if let unwrappedError = error {
                completionHandler(nil, unwrappedError)
            } else if let data = response {
                completionHandler(data, nil)
            }
        }
        
    }
    
    func loadMorePhotos(offset: Int, completionHandler: @escaping (_ response: [Photo]?, _ error: Error?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            if offset != 0 {
                sleep(2)
            }
            
            DispatchQueue.main.async(execute: {
                self.pageNumber += 1
                
                self.networkService.fetchPhotoData(pageNumber: self.pageNumber, photoType: .allPhoto, photoId: nil, username: nil, query: nil, completionHandler: { (response, error) in
                    if let unwrappedError = error {
                        completionHandler(nil, unwrappedError)
                    } else if let data = response {
                        completionHandler(data, nil)
                    }

                })
                
            })
            
        }
        
    }
    
    func loadMoreCollections(offset: Int, completionHandler: @escaping (_ response: [Collection]?, _ error: Error?) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            if offset != 0 {
                sleep(2)
            }
            
            DispatchQueue.main.async(execute: {
                self.collectionsPageNumber += 1

                self.networkService.fetchCollectionData(pageNumber: self.collectionsPageNumber, username: nil, collectionType: .allCollection, completioHandler: { (response, error) in
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
