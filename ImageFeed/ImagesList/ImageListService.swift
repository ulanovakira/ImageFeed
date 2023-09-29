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
    private var lastLoadedPage: Int =  1
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    let token = OAuth2TokenStorage().token
    
    func photosRequest(page: Int) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/photos?" + "page=\(page)&&per_page=10", httpMethod: "GET")
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        
        var request = photosRequest(page: lastLoadedPage)
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
                        name: ImageListService.didChangeNotification, object: self)
                    self.lastLoadedPage += 1
                case .failure(let error):
                    print("Failed to get photos \(error)")
                    break
                }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        var request = likeRequest(photoId: photoId, isLike: isLike)
        request?.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        guard let request = request else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error> ) in
            guard let self = self else { return }
            switch result {
            case .success(let likeResult):
                let newPhoto = LikedPhoto(likedPhotoResult: likeResult)
                if let index = self.photos.firstIndex(where: {$0.id == photoId}) {
                    var photo = self.photos[index]
                    photo.isLiked = newPhoto.likedPhoto.likedByUser
                    self.photos[index] = photo
                    completion(.success(photo.isLiked))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func likeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: isLike ? "POST" : "DELETE")
    }
}
