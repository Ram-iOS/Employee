//
//  DataService.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import Combine

final class DataService: DataServiceProtocol {
    
    // MARK: Initializer
    
    /// Create a instance of `DataService`
    init() {}
}

extension DataService {
    /// Fetch company details
    /// - Parameter id: Use to find the company based on id
    /// - Returns: Returns `CompanyModel` or `ServiceError` in case of error.
    func getAllCompanies(
        withCompanyEmail email: String
    ) -> AnyPublisher<[CompanyModel], ServiceError> {
        return Future { promise in
            do {
                let fm = FileManager.default
                let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
                if let url = urls.first {
                    var fileURL = url.appendingPathComponent(AppConstant.jsonFilename)
                    fileURL = fileURL.appendingPathExtension("json")
                    let data = try Data(contentsOf: fileURL)
                    let value: JSONResponse<[CompanyDTO]> = try data.decode()
                    let companyDTOs = value.data
                    promise(.success(companyDTOs.map({ $0.toCompanyModel() })))
                } else {
                    promise(.failure(.customError(errorMessage: "Unable to find json file")))
                }
            } catch {
                promise(.failure(.customError(errorMessage: "Failed to generate data")))
            }
        }.eraseToAnyPublisher()
    }
    
    
    /// Fetch company details
    /// - Parameter id: Use to find the company based on id
    /// - Returns: Returns `CompanyModel` or `ServiceError` in case of error.
    func getCompanyDetails(
        withCompanyEmail email: String
    ) -> AnyPublisher<CompanyModel, ServiceError> {
        return Future { promise in
            do {
                let fm = FileManager.default
                let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
                if let url = urls.first {
                    var fileURL = url.appendingPathComponent(AppConstant.jsonFilename)
                    fileURL = fileURL.appendingPathExtension("json")
                    let data = try Data(contentsOf: fileURL)
                    let value: JSONResponse<[CompanyDTO]> = try data.decode()
                    let companyDTOs = value.data
                    if let model = companyDTOs.map({ $0.toCompanyModel() })
                        .first(where: { $0.companyEmail.lowercased() ==  email.lowercased()}) {
                        promise(.success(model))
                    } else {
                        promise(.failure(.customError(errorMessage: "Failed to get company details")))
                    }
                } else {
                    promise(.failure(.customError(errorMessage: "Unable to find json file")))
                }
            } catch {
                promise(.failure(.customError(errorMessage: "Failed to generate data")))
            }
        }.eraseToAnyPublisher()
    }
    
    /// Save company DTO
    /// - Parameter dto: The company dto
    /// - Returns: Returns `Bool` or `Service` in case of error.
    func saveCompanyDetail(
        withCompanyDTO dto: JSONResponse<[CompanyDTO]>
    ) -> AnyPublisher<Bool, ServiceError> {
        return Future { promise in
            let fm = FileManager.default
            let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
            if let url = urls.first {
                var fileURL = url.appending(path: AppConstant.jsonFilename)
                fileURL = fileURL.appendingPathExtension("json")
                do {
                    let jsonData = try JSONEncoder().encode(dto)
                    try jsonData.write(to: fileURL, options: [.atomicWrite])
                    promise(.success(true))
                } catch {
                    promise(.failure(.customError(errorMessage: "Failed to write")))
                }
            } else {
                promise(.failure(.customError(errorMessage: "Unable to find json file")))
            }
        }.eraseToAnyPublisher()
    }
}
