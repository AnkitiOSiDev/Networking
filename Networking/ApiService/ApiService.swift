//
//  ApiService.swift
//  NetworkLayerSolid
//
//  Created by Ankit on 04/05/24.
//

import Foundation

public protocol ApiServiceProtocol {
    var  networkManager: NetworkManagerProtocol { get }
}

public extension ApiServiceProtocol {
    func getData<Model: ResponseBody>(endpoint: ApiRequestable,
                                   parser: ResponseParser<Model> = ResponseParser<Model>(),
                                   completion: @escaping (Result<Model, NetworkError>) -> Void) {
        networkManager.request(endpoint, parser: parser) { (result: Result<Model, NetworkError>) in
            completion(result)
        }
    }
}

//
//protocol NetworkMGR {
//    func request<Model>(request: ApiRequestable, parser: @escaping (Data) throws -> Void, completion: @escaping (Result<Model, NetworkError>) -> Void )
//}
//
//protocol ApiServable {
//
//}
//
//extension ApiServiceProtocol1 {
//    func getData<Model: ResponseBody>(request: ApiRequestable, parser: ResponseParser<Model>, completion: @escaping (Result<Model, NetworkError>) -> Void )
//}
//
//protocol ApiReqsble {
//    var url: URL? {get}
//
//}
//
