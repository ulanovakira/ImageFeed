//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Кира on 29.09.2023.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func observeNotifications()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func observeNotifications() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.DidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.view?.updateAvatar()
        }
        view?.updateAvatar()
    }
    
    var view: ProfileViewControllerProtocol?
}
