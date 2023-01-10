//
//  ViewModelProtocol.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import Combine

protocol ViewModelProtocol {
    
    /// Fetch company details
    /// - Parameter id: Use to fetch the details
    func fetchCompanyDetail(
        withCompanyEmail email: String
    )
}
