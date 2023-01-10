//
//  AppState.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation

/// The model represents the current state of loading
/// company details
struct CompanyLoadingState: Equatable {
    
    /// The controller state
    let controllerState: ControllerStates
    
    /// The company info
    let company: CompanyModel?
    
    /// Initial state
    static let initial = CompanyLoadingState(
        controllerState: .initial,
        company: nil
    )
    
    static func == (lhs: CompanyLoadingState, rhs: CompanyLoadingState) -> Bool {
        return lhs.controllerState == rhs.controllerState
    }
    
    /// Copy the new state of controller
    /// - Parameters:
    ///   - controllerState: The current state of controller
    ///   - company: The company details associated to state
    /// - Returns: new instance of `CompanyLoadingState`.
    func updateSate(
        controllerState: ControllerStates? = nil,
        company: CompanyModel? = nil
    ) -> CompanyLoadingState {
        .init(
            controllerState: controllerState ?? self.controllerState,
            company: company ?? self.company
        )
    }
}

enum ControllerStates: Equatable {
    case initial
    case loading
    case success
    case error(message: String?)
}
