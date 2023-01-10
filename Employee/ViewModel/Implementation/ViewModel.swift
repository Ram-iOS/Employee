//
//  ViewModel.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import Combine
import RxSwift
import RxRelay

final class ViewModel: ViewModelProtocol {
    /// The service associated to view model
    let service: DataServiceProtocol
    
    /// The cancellables stores
    var cancellables = Set<AnyCancellable>()
    
    /// The dispose bag
    var disposebag = DisposeBag()
    
    /// The observer on email field
    var emailObservable: BehaviorRelay<String> = BehaviorRelay(value: .empty)
    
    /// The boolean to enable / disable button
    private(set) var isValidInput: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    /// The state of controller
    private(set) var state: BehaviorRelay<CompanyLoadingState> = BehaviorRelay(value: .initial)
    
    /// The array of employees
    var employees: BehaviorRelay<[EmployeeModel]> = BehaviorRelay(value: [])
    
    // MARK: Initializers
    
    /// Create a single instance of
    /// `ViewModel`
    ///
    /// - Parameters: Service associated to view model.
    init(
        service: DataServiceProtocol = DataService()
    ) {
        self.service = service
    }
    
    /// Email validtion
    /// TODO: If there are multiple fields then need to use
    /// CombineLatest
    func enableValidationForEmail() {
        emailObservable.asObservable().subscribe(onNext: { [weak self] email in
            guard let self = self else { return }
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            self.isValidInput.accept(emailPred.evaluate(with: email))
        }).disposed(by: self.disposebag)
    }
}

extension ViewModel {
    /// Fetch company details
    /// - Parameter id: Use to fetch the details
    func fetchCompanyDetail(
        withCompanyEmail email: String
    ) {
        self.state.accept(self.state.value.updateSate(controllerState: .loading))
        self.service.getCompanyDetails(withCompanyEmail: email)
            .sink { handler in
                switch handler {
                case let .failure(error):
                    self.state.accept(
                        self.state.value.updateSate(
                            controllerState: .error(message: error.description)
                        )
                    )
                default: break
                }
            } receiveValue: { company in
                self.state.accept(
                    self.state.value.updateSate(
                        controllerState: .success,
                        company: company
                    )
                )
                self.employees.accept(company.employees)
            }
            .store(in: &self.cancellables)
    }
    
}
