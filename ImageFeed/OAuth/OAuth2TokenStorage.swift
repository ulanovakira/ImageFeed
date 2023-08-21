//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Кира on 10.08.2023.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    private enum CodingKeys: String {
        case token
    }
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: CodingKeys.token.rawValue)
        }
        set {
            KeychainWrapper.standard.set(newValue!, forKey: CodingKeys.token.rawValue)
        }
    }
}
