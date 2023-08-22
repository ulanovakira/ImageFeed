//
//  Profile.swift
//  ImageFeed
//
//  Created by Кира on 20.08.2023.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    var loginName: String {
        get {
            "@\(username)"
        }
    }
    let bio: String?
}
