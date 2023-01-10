//
//  RegisterViewModelProtocol.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation

protocol RegisterViewModelProtocol {
    /// Register company
    /// - Parameters:
    ///   - name: The name of company
    ///   - email: The email of company
    func registerCompany(
        name: String,
        email: String
    )
}
