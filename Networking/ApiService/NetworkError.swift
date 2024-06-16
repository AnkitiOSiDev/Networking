//
//  NetworkError.swift
//  NetworkLayerSolid
//
//  Created by Ankit on 04/05/24.
//

import Foundation

public enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case noData
    case httpResponseError(statusCode: Int)
    case apiError(error: Error)
    case parsingError
}

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.invalidResponse, .invalidResponse):
            return true
        case (.noData, .noData):
            return true
        case (.parsingError, .parsingError):
            return true
        case (.httpResponseError(let statusCode), .httpResponseError(let statusCode1)):
            return statusCode == statusCode1
        case (.apiError(let apiError), .apiError(let apiError1)):
            return apiError.localizedDescription == apiError1.localizedDescription
        default:
            return false
        }
    }
}
