//
//  Extension+Data.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation

extension Data {
    func decode<T: Decodable>() throws -> T {
        let decorder = JSONDecoder()
        do {
            return try decorder.decode(T.self, from: self)
        } catch let error as DecodingError {
            print("data decoding error: \(error)")
            throw error
        }
    }
}
