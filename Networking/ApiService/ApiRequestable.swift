//
//  ApiRequestable.swift
//  NetworkLayerSolid
//
//  Created by Ankit on 04/05/24.
//

import Foundation

public protocol ApiRequestable {
    var baseURL: URL? { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HttpMethod { get }
    var headers: [String: String]? { get }
    var body: RequestBody? { get }
    var urlRequest: URLRequest? { get }
}

public extension ApiRequestable {
    var urlRequest: URLRequest? {
        guard let baseURL = baseURL,
              var components = URLComponents(url: baseURL.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: true)
        else { return nil }
        
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body?.jsonData()
        return request
    }
}
