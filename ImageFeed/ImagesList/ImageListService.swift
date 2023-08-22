//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Кира on 21.08.2023.
//

import Foundation

final class ImageListService {
    static let shared = ImageListService()
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let DidChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    let token = OAuth2TokenStorage().token
    
    func photosRequest(page: Int) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/photos?" + "page=\(page)&order_by=latest", httpMethod: "GET")
    }
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        task?.cancel()
//        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        var request = photosRequest(page: nextPage)
        request?.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                guard let self = self else { return }
            print("result \(result)")
                switch result {
                case .success(let body):
                    for photo in body {
                        self.photos.append(Photo(result: photo))
                    }
                    NotificationCenter.default.post(
                        name: ImageListService.DidChangeNotification, object: self)
                    self.lastLoadedPage = nextPage
                case .failure(let error):
                    print("Failed to get photos \(error)")
                    break
                }
        }
        self.task = task
        task.resume()
    }
}
