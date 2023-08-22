//
//  URLRequest.swift
//  ImageFeed
//
//  Created by Кира on 10.08.2023.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequest(
                path: String,
                httpMethod: String,
                baseURL: URL = apiBaseURL
            ) -> URLRequest {
                var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
                request.httpMethod = httpMethod
                return request
            }
}
