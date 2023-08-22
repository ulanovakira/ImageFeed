//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Кира on 20.08.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}



struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
