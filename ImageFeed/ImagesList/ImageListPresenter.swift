//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Кира on 30.09.2023.
//

import Foundation

public protocol ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol? { get set }
    func observeNotifications()
}

final class ImageListPresenter: ImageListPresenterProtocol {
    var view: ImageListViewControllerProtocol?
    private var imageListServiceObserver: NSObjectProtocol?
    
    func observeNotifications() {
        imageListServiceObserver = NotificationCenter.default.addObserver(forName:ImageListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.view?.updateTableViewAnimated()
        }
    }
    
    
}
