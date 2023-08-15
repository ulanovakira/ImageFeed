//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Кира on 10.08.2023.
//

import Foundation
import UIKit

class OAuth2TokenStorage {
    private enum CodingKeys: String {
        case token
    }
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: CodingKeys.token.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: CodingKeys.token.rawValue)
        }
    }
}
