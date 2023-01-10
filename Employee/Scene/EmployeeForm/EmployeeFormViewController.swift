//
//  EmployeeFormViewController.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import UIKit

class EmployeeFormViewController: UIViewController {

    var employee: EmployeeModel?
    var companyEmail: String = .empty
    
    private let viewModel = EmployeeViewModel()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var resignedStackView: UIStackView!
    @IBOutlet weak var resignedSwitch: UISwitch!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = employee == nil ? "Add" : "Edit"
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
            self.saveButton.isUserInteractionEnabled = valid
            self.saveButton.alpha = valid ? 1 : 0.5
        }.disposed(by: viewModel.disposebag)
        
        self.emailTextField.rx.text.orEmpty.bind(
            to: self.viewModel.emailObservable
        ).disposed(by: viewModel.disposebag)
        
        self.nameTextField.rx.text.orEmpty.bind(
            to: self.viewModel.nameObservable
        ).disposed(by: viewModel.disposebag)
        
        self.departmentTextField.rx.text.orEmpty.bind(
            to: self.viewModel.departmentObservable
        ).disposed(by: viewModel.disposebag)
        
        self.viewModel.enableValidation()
        
        if let employee = self.employee {
            self.deleteButton.isHidden = false
            self.resignedStackView.isHidden = false
            self.nameTextField.text = employee.name
            self.emailTextField.text = employee.email
            self.departmentTextField.text = employee.department
            self.resignedSwitch.setOn(!employee.active, animated: true)
            self.viewModel.nameObservable.accept(employee.name)
            self.viewModel.emailObservable.accept(employee.email)
            self.viewModel.departmentObservable.accept(employee.department)
        } else {
            self.deleteButton.isHidden = true
            self.resignedStackView.isHidden = true
        }
        
        self.saveButton.rx.controlEvent([.touchUpInside]).bind { [weak self] in
            guard let self = self else { return }
            if var model = self.employee {
                model.email = self.emailTextField.text ?? .empty
                model.department = self.departmentTextField.text ?? .empty
                model.name = self.nameTextField.text ?? .empty
                model.active = !self.resignedSwitch.isOn
                self.viewModel.updateEmployee(companyEmail: self.companyEmail, model: model)
            } else {
                let model = EmployeeModel(
                    name: self.nameTextField.text ?? .empty,
                    email: self.emailTextField.text ?? .empty,
                    department: self.departmentTextField.text ?? .empty,
                    id: UUID().uuidString,
                    active: true
                )
                self.viewModel.saveEmployee(companyEmail: self.companyEmail, model: model)
            }
        }.disposed(by: viewModel.disposebag)
        
        self.deleteButton.rx.controlEvent([.touchUpInside]).bind { [weak self] in
            guard let self = self else { return }
            if let model = self.employee {
                self.viewModel.deleteEmployee(companyEmail: self.companyEmail, model: model)
            }
        }.disposed(by: viewModel.disposebag)
    }

}
