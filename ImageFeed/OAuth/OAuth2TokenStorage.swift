//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Кира on 10.08.2023.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import WebKit

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
    
    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { resords in
            resords.forEach{ record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    static func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: CodingKeys.token.rawValue)
    }
}
