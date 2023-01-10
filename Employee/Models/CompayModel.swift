//
//  CompayModel.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation

/// The model represents the single object of
/// `CompanyModel`
struct CompanyModel {
    /// The unique identifier
    let id: String = UUID().uuidString
    
    /// The email associated to `CompanyModel`
    let companyEmail: String
    
    /// The name associated to `CompanyModel`
    let companyName: String
    
    /// The list of employee associcated to `CompanyModel`
    var employees: [EmployeeModel]
}

/// The model represents the single object of `EmployeeModel`
struct EmployeeModel {
    /// The name associated to `EmployeeModel`
    var name: String
    
    /// The email associated to `EmployeeModel`
    var email: String
    
    /// The department associated to `EmployeeModel`
    var department: String
    
    /// The id associated to `EmployeeModel`
    var id: String
    
    /// The state of `EmployeeModel`
    var active: Bool
}

extension CompanyModel {
    func toCompanyDTO() -> CompanyDTO {
        .init(
            companyEmail: self.companyEmail,
            companyName: self.companyName,
            employees: self.employees.map({ $0.toEmployeDTO() })
        )
    }
}

extension EmployeeModel {
    func toEmployeDTO() -> EmployeeDTO {
        .init(
            name: self.name,
            email: self.email,
            department: self.department,
            id: self.id,
            active: self.active
        )
    }
}
