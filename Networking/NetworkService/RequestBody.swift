//
//  RequestBody.swift
//  NetworkLayerSolid
//
//  Created by Ankit on 04/05/24.
//

import Foundation

public protocol RequestBody: Encodable { }

public extension Encodable {
    func jsonData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
