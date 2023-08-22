//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Кира on 20.08.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    let token = OAuth2TokenStorage().token
    
    func profileImageURLRequest(username: String) -> URLRequest? {
        return URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if avatarURL != nil { return }
        task?.cancel()
        var request = profileImageURLRequest(username: username)
        request?.addValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        guard let request = request else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                    case .success(let body):
                        let avatarURL = body.profileImage?.small
                        guard let avatarURL = avatarURL else {return}
                        self.avatarURL = avatarURL
                        completion(.success(avatarURL))
                        NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification,
                                                        object: self,
                                                        userInfo: ["URL": avatarURL])
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.avatarURL = nil
                }
            }
        }
        self.task = task
        task.resume()
        
        
    }
}
//extension ProfileImageService {
//    func object(
//        for request: URLRequest,
//        completion: @escaping (Result<UserResult, Error>) -> Void
//    ) -> URLSessionTask {
//        let decoder = JSONDecoder()
//        return urlSession.data(for: request) { (result: Result<Data, Error>) in
//            let response = result.flatMap { data -> Result<UserResult, Error> in
//                Result {
//                    try decoder.decode(UserResult.self, from: data)
//                }
//            }
//            completion(response)
//        }
//    }
//}
