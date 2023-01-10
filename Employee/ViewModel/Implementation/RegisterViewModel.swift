//
//  RegisterViewModel.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import Foundation
import Combine
import RxSwift
import RxRelay

final class RegisterViewModel: RegisterViewModelProtocol {
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
        Observable.combineLatest(self.emailObservable.asObservable(), self.nameObservable.asObservable()) { email, name in
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email) && name.count > 1
        }.asObservable().subscribe(onNext: { [weak self] success in
            guard let self = self else { return }
            self.isValidInput.accept(success)
        }).disposed(by: self.disposebag)
    }
   
}


extension RegisterViewModel {
    /// Register company
    /// - Parameters:
    ///   - name: The name of company
    ///   - email: The email of company
    func registerCompany(
        name: String,
        email: String
    ) {
        self.controllerState.accept(.loading)
        
        self.service.getAllCompanies(withCompanyEmail: email)
            .sink { handler in
                switch handler {
                case let .failure(error):
                    self.controllerState.accept(.error(message: error.description))
                default: break
                }
            } receiveValue: { companies in
                var cmps = companies
                if let _ = cmps.firstIndex(where: { $0.companyEmail == email }) {
                    self.controllerState.accept(.error(message: "Already exists"))
                } else {
                    cmps.append(.init(companyEmail: email, companyName: name, employees: []))
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
