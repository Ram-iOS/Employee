//
//  RegisterViewController.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import UIKit
import RxCocoa

class RegisterViewController: UIViewController {

    /// The view model associated to controller
    private let viewModel = RegisterViewModel()
    
    /// The name input field
    @IBOutlet weak private var nameTextField: UITextField!
    
    /// The email input field
    @IBOutlet weak private var emailTextField: UITextField!
    
    /// The register button
    @IBOutlet weak private var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        configureProperties()
    }
    
    private func configureProperties() {
        
        self.viewModel.controllerState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case let .error(message):
                print(message ?? .empty)
            default: break
            }
        }).disposed(by: viewModel.disposebag)
        
        self.viewModel.isValidInput.asObservable().subscribe { [weak self] valid in
            guard let self = self else { return }
            self.registerButton.isUserInteractionEnabled = valid
            self.registerButton.alpha = valid ? 1 : 0.5
        }.disposed(by: viewModel.disposebag)
        
        self.emailTextField.rx.text.orEmpty.bind(
            to: self.viewModel.emailObservable
        ).disposed(by: viewModel.disposebag)
        
        self.nameTextField.rx.text.orEmpty.bind(
            to: self.viewModel.nameObservable
        ).disposed(by: viewModel.disposebag)
        
        self.viewModel.enableValidation()
        
        self.registerButton.rx.controlEvent([.touchUpInside]).bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.registerCompany(name: self.nameTextField.text ?? .empty, email: self.emailTextField.text ?? .empty)
        }.disposed(by: viewModel.disposebag)
    }

}
