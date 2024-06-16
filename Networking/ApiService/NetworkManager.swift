//
//  NetworkManager.swift
//  NetworkLayerSolid
//
//  Created by Ankit on 04/05/24.
//

import Foundation

public protocol NetworkManagerProtocol {
    func request<Model>(_ endpoint: ApiRequestable,
                        parser: ResponseParser<Model> ,
                        completion: @escaping (Result<Model, NetworkError>) -> Void)
}

public final class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<Model>(_ endpoint: ApiRequestable,
                        parser: ResponseParser<Model>,
                        completion: @escaping (Result<Model, NetworkError>) -> Void) {
        guard let urlRequest = endpoint.urlRequest else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }

            let task = session.dataTask(with: urlRequest) { data, response, error in
                        if let error = error {
                            completion(.failure(NetworkError.apiError(error: error)))
                            return
                        }

                        guard let httpResponse = response as? HTTPURLResponse else {
                            completion(.failure(NetworkError.invalidResponse))
                            return
                        }

                        if (200..<300).contains(httpResponse.statusCode) {
                            guard let data = data else {
                                completion(.failure(NetworkError.noData))
                                return
                            }

                            do {
                                let model = try parser.parse(data: data)
                                completion(.success(model))
                            } catch {
                                completion(.failure(.parsingError))
                            }
                        } else {
                            // HTTP Error
                            completion(.failure(NetworkError.httpResponseError(statusCode: httpResponse.statusCode)))
                        }
                    }
                task.resume()
    }
}
