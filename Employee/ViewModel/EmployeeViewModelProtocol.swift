//
//  EmployeeViewModelProtocol.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation

protocol EmployeeViewModelProtocol {
    
    /// Save employee
    /// - Parameter model: The employee model
    func saveEmployee(
        companyEmail: String,
        model: EmployeeModel
    )
}
