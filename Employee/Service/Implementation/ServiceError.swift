//
//  ServiceError.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation

/// The enum represnts the error
enum ServiceError: LocalizedError, CustomStringConvertible {
    case invalidURL
    case parsingFailure
    case customError(errorMessage: String)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid url"
        case .parsingFailure:
            return "Parsing failure"
        case let .customError(errorMessage):
            return errorMessage
        }
    }
}
