//
//  DataServiceProtocol.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import Combine

protocol DataServiceProtocol {
    /// Fetch company details
    /// - Parameter id: Use to find the company based on id
    /// - Returns: Returns `CompanyModel` or `ServiceError` in case of error.
    func getCompanyDetails(
        withCompanyEmail email: String
    ) -> AnyPublisher<CompanyModel, ServiceError>
    
    /// Fetch company details
    /// - Parameter id: Use to find the company based on id
    /// - Returns: Returns `CompanyModel` or `ServiceError` in case of error.
    func getAllCompanies(
        withCompanyEmail email: String
    ) -> AnyPublisher<[CompanyModel], ServiceError>
    
    
    /// Save company DTO
    /// - Parameter dto: The company dto
    /// - Returns: Returns `Bool` or `Service` in case of error.
    func saveCompanyDetail(
        withCompanyDTO dto: JSONResponse<[CompanyDTO]>
    ) -> AnyPublisher<Bool, ServiceError>
}



