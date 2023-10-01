//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Кира on 28.09.2023.
//

import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var viewDidRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        viewDidRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
