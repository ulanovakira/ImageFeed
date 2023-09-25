//
//  Photo.swift
//  ImageFeed
//
//  Created by Кира on 21.08.2023.
//

import Foundation
let dateFormatter = ISO8601DateFormatter()

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    var isLiked: Bool
    
    init(result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = dateFormatter.date(from: result.createdAt ?? "")
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = result.likedByUser
    }
}

struct LikedPhoto {
    var likedPhoto: PhotoResult
    
    init(likedPhotoResult: LikePhotoResult) {
        self.likedPhoto = likedPhotoResult.photo
    }
}
