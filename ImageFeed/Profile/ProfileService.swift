//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Кира on 20.08.2023.
//

import Foundation

final class ProfileService {
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    
    var selfProfileRequest: URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET", baseURL: apiBaseURL)
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        
        var request = selfProfileRequest
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let request = request else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result:Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                    case .success(let body):
                        let profile = Profile(
                            username: body.username,
                            name: "\(body.firstName) \(body.lastName)",
                            bio: body.bio ?? nil)
                        self.profile = profile
                        completion(.success(profile))
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.profile = nil
                }
            }
        }
        self.task = task
        task.resume()
        
    }
}
