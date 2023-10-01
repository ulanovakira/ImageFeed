//
//  ProfileTest.swift
//  ImageFeedTests
//
//  Created by Кира on 29.09.2023.
//

import XCTest
@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var observeNotificationsCalled: Bool = false
    
    func observeNotifications() {
        observeNotificationsCalled = true
    }
    
    var view: ProfileViewControllerProtocol?
}

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.observeNotifications()
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.observeNotificationsCalled)
    }
}
