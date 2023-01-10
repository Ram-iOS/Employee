//
//  ViewController.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

final class ViewController: UIViewController {

    /// The view model associated to controller
    let viewModel = ViewModel()
    
    /// The input field use to take email
    @IBOutlet weak private var emailTextField: UITextField!
    
    /// Use to fetch the company details
    @IBOutlet weak private var fetchButton: UIButton!
    
    /// register button
    @IBOutlet weak private var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.isValidInput.asObservable().subscribe { [weak self] valid in
            guard let self = self else { return }
            self.fetchButton.isUserInteractionEnabled = valid
            self.fetchButton.alpha = valid ? 1 : 0.5
        }.disposed(by: viewModel.disposebag)
        
        /// bindig email text
        self.emailTextField.rx.text.orEmpty.bind(
            to: self.viewModel.emailObservable
        ).disposed(by: viewModel.disposebag)
        
        self.viewModel.enableValidationForEmail()
        
        self.fetchButton.rx.controlEvent([.touchUpInside]).bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchCompanyDetail(withCompanyEmail: self.emailTextField.text ?? .empty)
        }.disposed(by: viewModel.disposebag)
        
        self.viewModel.state.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state.controllerState {
            case let .error(message):
                print(message ?? .empty)
            case .success:
                if let model = state.company {
                    /// redirect to employee list
                    let employeeViewController = EmployeeViewController.instantiate()
                    employeeViewController.company = model
                    self.navigationController?.pushViewController(employeeViewController, animated: true)
                }
            default: break
            }
        }).disposed(by: viewModel.disposebag)
        
        self.registerButton.rx.controlEvent([.touchUpInside]).bind { [weak self] in
            guard let self = self else { return }
            let registerViewController = RegisterViewController.instantiate()
            self.navigationController?.pushViewController(registerViewController, animated: true)
        }.disposed(by: viewModel.disposebag)
    }

}

