//
//  DataServiceTests.swift
//  EmployeeTests
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import Combine
import XCTest

@testable import Employee

class DataServiceTests: AppTestCase {
    
    private var service: DataServiceProtocol!
    
    
    override func beforeEarch() {
        service = DataService()
    }
    
    func test_that_register_company_success() {
        // given
        let email = "test@gmail.com"
        let name = "test"
        
        let expectation = expectation(description: #function)
        var result: Bool = false
        
        /// when
        self.service.saveCompanyDetail(
            withCompanyDTO: .init(data: [.init(companyEmail: email, companyName: name, employees: nil)])
        )
        .sink { _ in
            expectation.fulfill()
        } receiveValue: { success in
            result = success
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
        XCTAssertTrue(result)
    }
    
    func test_that_get_comapny_detail_success() {
        // given
        let email = "test@gmail.com"
        
        let expectation = expectation(description: #function)
        var result: CompanyModel?
        
        /// when
        self.service.getCompanyDetails(withCompanyEmail: email)
        .sink { _ in
            expectation.fulfill()
        } receiveValue: { companyModel in
            result = companyModel
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
        
        XCTAssertEqual(result?.companyEmail, "test@gmail.com")
    }
    
    func test_that_employee_add_success() {
        // given
        let email = "test@gmail.com"
        let name = "test"
        
        let expectation = expectation(description: #function)
        var result: Bool = false
        
        /// when
        self.service.saveCompanyDetail(
            withCompanyDTO: .init(
                data: [
                    .init(
                        companyEmail: email,
                        companyName: name,
                        employees: [
                            .init(
                                name: "test",
                                email: "test",
                                department: "test",
                                id: "test",
                                active: false
                            )
                        ]
                    )
                ]
            )
        )
        .sink { _ in
            expectation.fulfill()
        } receiveValue: { success in
            result = success
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
        
        XCTAssertTrue(result)
        
    }
    
    func test_that_get_comapny_employees_success() {
        // given
        let email = "test@gmail.com"
        
        let expectation = expectation(description: #function)
        var result: CompanyModel?
        
        /// when
        self.service.getCompanyDetails(withCompanyEmail: email)
        .sink { _ in
            expectation.fulfill()
        } receiveValue: { companyModel in
            result = companyModel
        }
        .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
        
        XCTAssertEqual(result?.companyEmail, "test@gmail.com")
        XCTAssertEqual(result?.employees.count, 1)
        XCTAssertEqual(result?.employees.first?.name, "test")
    }
}
