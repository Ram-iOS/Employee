//
//  EmployeeViewModel.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import RxSwift
import RxRelay
import Combine

final class EmployeeViewModel: EmployeeViewModelProtocol {
    /// The serive associated to view  model
    private let service: DataServiceProtocol
    
    /// The cancellables
    var cancellables = Set<AnyCancellable>()
    
    /// The dispose bag
    var disposebag = DisposeBag()
    
    /// The observer on email field
    var emailObservable: BehaviorRelay<String> = BehaviorRelay(value: .empty)
    
    /// The observer on email field
    var nameObservable: BehaviorRelay<String> = BehaviorRelay(value: .empty)
    
    /// The observer on email field
    var departmentObservable: BehaviorRelay<String> = BehaviorRelay(value: .empty)
    
    /// The boolean to enable / disable button
    private(set) var isValidInput: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    private(set) var controllerState: BehaviorRelay<ControllerStates> = BehaviorRelay(value: .initial)
    
    // MARK: Initializer
    
    /// Create a instance of `RegisterViewModel`
    /// - Parameter service: The service associated to view model.
    init(service: DataServiceProtocol = DataService()) {
        self.service = service
    }
    
    /// Email validtion
    /// TODO: If there are multiple fields then need to use
    /// CombineLatest
    func enableValidation() {
        Observable.combineLatest(self.emailObservable.asObservable(), self.nameObservable.asObservable(), self.departmentObservable.asObservable()) { email, name, department in
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email) && name.count > 1 && department.count > 1
        }.asObservable().subscribe(onNext: { [weak self] success in
            guard let self = self else { return }
            self.isValidInput.accept(success)
        }).disposed(by: self.disposebag)
    }
}

extension EmployeeViewModel {
    /// Save employee
    /// - Parameter model: The employee model
    func saveEmployee(
        companyEmail: String,
        model: EmployeeModel
    ) {
        self.service.getAllCompanies(withCompanyEmail: companyEmail)
            .sink { handler in
                switch handler {
                case let .failure(error):
                    self.controllerState.accept(.error(message: error.description))
                default: break
                }
            } receiveValue: { companies in
                var cmps = companies
                if var employes = cmps.first(where: { $0.companyEmail == companyEmail })?.employees {
                    employes.append(model)
                    cmps[cmps.firstIndex(where: { $0.companyEmail == companyEmail }) ?? 0].employees = employes
                    
                    self.service.saveCompanyDetail(withCompanyDTO: .init(data: cmps.map({ $0.toCompanyDTO() })))
                        .sink { handler in
                            switch handler {
                            case let .failure(error):
                                self.controllerState.accept(.error(message: error.description))
                            default: break
                            }
                        } receiveValue: { success in
                            self.controllerState.accept(.success)
                        }
                        .store(in: &self.cancellables)
                }
            }
            .store(in: &self.cancellables)
    }
    
    /// Save employee
    /// - Parameter model: The employee model
    func updateEmployee(
        companyEmail: String,
        model: EmployeeModel
    ) {
        self.service.getAllCompanies(withCompanyEmail: companyEmail)
            .sink { handler in
                switch handler {
                case let .failure(error):
                    self.controllerState.accept(.error(message: error.description))
                default: break
                }
            } receiveValue: { companies in
                var cmps = companies
                if var employes = cmps.first(where: { $0.companyEmail == companyEmail })?.employees {
                    if let idx = employes.firstIndex(where: { $0.id == model.id }) {
                        employes[idx] = model
                    }
                    cmps[cmps.firstIndex(where: { $0.companyEmail == companyEmail }) ?? 0].employees = employes
                    
                    self.service.saveCompanyDetail(withCompanyDTO: .init(data: cmps.map({ $0.toCompanyDTO() })))
                        .sink { handler in
                            switch handler {
                            case let .failure(error):
                                self.controllerState.accept(.error(message: error.description))
                            default: break
                            }
                        } receiveValue: { success in
                            self.controllerState.accept(.success)
                        }
                        .store(in: &self.cancellables)
                }
            }
            .store(in: &self.cancellables)
    }
    
    // Save employee
    /// - Parameter model: The employee model
    func deleteEmployee(
        companyEmail: String,
        model: EmployeeModel
    ) {
        self.service.getAllCompanies(withCompanyEmail: companyEmail)
            .sink { handler in
                switch handler {
                case let .failure(error):
                    self.controllerState.accept(.error(message: error.description))
                default: break
                }
            } receiveValue: { companies in
                var cmps = companies
                if var employes = cmps.first(where: { $0.companyEmail == companyEmail })?.employees {
                    if let idx = employes.firstIndex(where: { $0.id == model.id }) {
                        employes.remove(at: idx)
                    }
                    cmps[cmps.firstIndex(where: { $0.companyEmail == companyEmail }) ?? 0].employees = employes
                    
                    self.service.saveCompanyDetail(withCompanyDTO: .init(data: cmps.map({ $0.toCompanyDTO() })))
                        .sink { handler in
                            switch handler {
                            case let .failure(error):
                                self.controllerState.accept(.error(message: error.description))
                            default: break
                            }
                        } receiveValue: { success in
                            self.controllerState.accept(.success)
                        }
                        .store(in: &self.cancellables)
                }
            }
            .store(in: &self.cancellables)
    }
}
