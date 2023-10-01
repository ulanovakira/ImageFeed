//
//  ImageListTest.swift
//  ImageFeedTests
//
//  Created by Кира on 29.09.2023.
//

import XCTest
@testable import ImageFeed

final class ImageListPresenterSpy: ImageListPresenterProtocol {
    var observeNotificationsCalled: Bool = false
    
    func observeNotifications() {
        observeNotificationsCalled = true
    }
    
    var view: ImageListViewControllerProtocol?
}

final class ImageListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ImageListViewController()
        let presenter = ImageListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.observeNotifications()
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.observeNotificationsCalled)
    }
}
