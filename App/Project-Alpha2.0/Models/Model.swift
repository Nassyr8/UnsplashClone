//
//  Model.swift
//  Project-Alpha2.0
//
//  Created by Nassyrkhan Seitzhapparuly on 7/29/19.
//  Copyright © 2019 Мадияр. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Collection {
    var id: Int
    var title: String
    var description: String
    var publishedAt: String
    var updatedAt: String
    var totalPhotos: Int
    var links: Links
    var user: SponsorAndUser
    var coverPhoto: Photo
    var previewPhotos: [PreviewPhoto]
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.publishedAt = json["published_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        self.totalPhotos = json["total_photos"].intValue
        self.links = Links(json: json["links"])
        self.user = SponsorAndUser(json: json["user"])
        self.coverPhoto = Photo(json: json["cover_photo"])
        
        var array = [PreviewPhoto]()
        if let list = json["preview_photos"].array {
            list.forEach { (previewPhoto) in
                array.append(PreviewPhoto(json: previewPhoto))
            }
        }
        self.previewPhotos = array
    }
}

struct Photo {
    var id: String
    var createdAt: String
    var updatedAt: String
    var width: Int
    var height: Int
    var color: String
    var description: String
    var altDescription: String
    var exif: Exif
    var urls: URLS
    var links: Links
    var sponsorship: SponsorAndUser
    var likes: Int
    var user: SponsorAndUser
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.createdAt = json["created_at"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.color = json["color"].stringValue
        self.description = json["description"].stringValue
        self.altDescription = json["alt_description"].stringValue
        self.urls = URLS(json: json["urls"])
        self.links = Links(json: json["links"])
        self.sponsorship = SponsorAndUser(json: json["sponsorship"]["sponsor"])
        self.likes = json["likes"].intValue
        self.user = SponsorAndUser(json: json["user"])
        self.exif = Exif(json: json["exif"])
    }
}

struct URLS {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
    
    init(json: JSON) {
        self.raw = json["raw"].stringValue
        self.full = json["full"].stringValue
        self.regular = json["regular"].stringValue
        self.small = json["small"].stringValue
        self.thumb = json["thumb"].stringValue
    }
}

struct Links {
    var selfLink: String
    var html: String
    var download: String
    var downloadLocation: String
    var photos: String
    var likes: String
    var portfolio: String
    var following: String
    var followers: String
    var related: String
    
    init(json: JSON) {
        self.selfLink = json["self"].stringValue
        self.html = json["html"].stringValue
        self.download = json["download"].stringValue
        self.downloadLocation = json["download_location"].stringValue
        self.likes = json["likes"].stringValue
        self.photos = json["photos"].stringValue
        self.portfolio = json["portfolio"].stringValue
        self.following = json["following"].stringValue
        self.followers = json["followers"].stringValue
        self.related = json["related"].stringValue
    }
}

struct SponsorAndUser {
    var id: String
    var updatedAt: String
    var username: String
    var name: String
    var twitterUsername: String
    var portfolioUrl: String
    var bio: String
    var location: String
    var links: Links
    var profileImage: ProfileImage
    var instagramUsername: String
    var totalCollections: Int
    var totalLikes: Int
    var totalPhotos: Int
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.updatedAt = json["updated_at"].stringValue
        self.username = json["username"].stringValue
        self.name = json["name"].stringValue
        self.twitterUsername = json["twitter_username"].stringValue
        self.portfolioUrl = json["portfolio_url"].stringValue
        self.bio = json["bio"].stringValue
        self.location = json["location"].stringValue
        self.links = Links(json: json["links"])
        self.profileImage = ProfileImage(json: json["profile_image"])
        self.instagramUsername = json["instagram_username"].stringValue
        self.totalCollections = json["total_collections"].intValue
        self.totalLikes = json["total_likes"].intValue
        self.totalPhotos = json["total_photos"].intValue
    }
}

struct ProfileImage {
    var small: String
    var medium: String
    var large: String
    
    init(json: JSON) {
        self.small = json["small"].stringValue
        self.medium = json["medium"].stringValue
        self.large = json["large"].stringValue
    }
}

struct PreviewPhoto {
    var id: String
    var urls: URLS
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.urls = URLS(json: json["urls"])
    }
}

struct Exif {
    var make: String
    var model: String
    var exposuretTime: String
    var aperture: String
    var focalLength: String
    var iso: String
    
    init(json: JSON) {
        self.make = json["make"].stringValue
        self.model = json["model"].stringValue
        self.exposuretTime = json["exposure_time"].stringValue
        self.aperture = json["aperture"].stringValue
        self.focalLength = json["focal_length"].stringValue
        self.iso = json["iso"].stringValue
    }
}
