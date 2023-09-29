//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Кира on 29.09.2023.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var observeNotificationsCalled: Bool = false
    
    func observeNotifications() {
        observeNotificationsCalled = true
    }
    
    var view: ProfileViewControllerProtocol?
}
