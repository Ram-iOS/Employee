//
//  AppTests.swift
//  EmployeeTests
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import XCTest
import Combine

@testable import Employee

class AppTestCase: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    final override func setUp() {
        beforeEarch()
    }
    
    final override func tearDown() {
        afterEach()
        super.tearDown()
    }
    
    func beforeEarch() {}
    func afterEach() {}
}
