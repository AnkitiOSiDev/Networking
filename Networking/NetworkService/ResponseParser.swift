//
//  ResponseParser.swift
//  NetworkLayerSolid
//
//  Created by Ankit on 04/05/24.
//

import Foundation

public typealias ResponseBody = Decodable

public struct ResponseParser<Model: ResponseBody> {
    public init() { }
    func parse(data: Data) throws -> Model {
        let decoder = JSONDecoder()
        return try decoder.decode(Model.self, from: data)
    }
}
