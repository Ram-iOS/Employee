//
//  CompanyDTO.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation

/// The model represent the `CompanyDTO`
struct CompanyDTO: Codable {
    /// The email associated to `CompanyDTO`
    let companyEmail: String?
    
    /// The name associated to `CompanyDTO`
    let companyName: String?
    
    /// The list of employee associcated to `CompanyDTO`
    let employees: [EmployeeDTO]?
    
    private enum CodingKeys: String, CodingKey {
        case companyEmail, companyName
        case employees = "Employees"
    }
}

struct EmployeeDTO: Codable {
    /// The name associated to `EmployeeDTO`
    let name: String?
    
    /// The email associated to `EmployeeDTO`
    let email: String?
    
    /// The department associated to `EmployeeDTO`
    let department: String?
    
    /// The id associated to `EmployeeDTO`
    let id: String?
    
    /// The state of `EmployeeDTO`
    let active: Bool?
}


extension CompanyDTO {
    func toCompanyModel() -> CompanyModel {
        .init(
            companyEmail: self.companyEmail ?? .empty,
            companyName: self.companyName ?? .empty,
            employees: self.employees?.map({ $0.toEmployeeModel() }) ?? []
        )
    }
}

extension EmployeeDTO {
    func toEmployeeModel() -> EmployeeModel {
        .init(
            name: self.name ?? .empty,
            email: self.email ?? .empty,
            department: self.department ?? .empty,
            id: self.id ?? .empty,
            active: self.active ?? true
        )
    }
}

// MARK: Generic response 
struct JSONResponse<T: Codable>: Codable {
    let data: T
}

