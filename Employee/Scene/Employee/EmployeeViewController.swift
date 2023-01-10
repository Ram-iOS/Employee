//
//  EmployeeViewController.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import UIKit

final class EmployeeViewController: UIViewController {

    /// The company detail passed from previous
    /// controller
    var company: CompanyModel?
    
    /// The view model associated to controller
    private let viewModel = ViewModel()
    
    /// The table view for employee list
    @IBOutlet weak private var tableView: UITableView!
    
    /// Add employee button
    @IBOutlet weak private var addEmployeeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = company?.companyName ?? .empty
        configureProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetchCompanyDetail(withCompanyEmail: company?.companyEmail ?? .empty)
    }
    
    private func configureProperties() {
        
        self.tableView.register(
            UINib(nibName: String(describing: EmployeeTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: EmployeeTableViewCell.self)
        )
        
        self.viewModel.employees.asObservable().bind(
            to: self.tableView.rx.items(
                cellIdentifier: String(describing: EmployeeTableViewCell.self),
                cellType: EmployeeTableViewCell.self
            )
        ) { row, model, cell in
            cell.configureCell(withEmployeeModel: model)
        }.disposed(by: viewModel.disposebag)
        
        self.viewModel.employees.accept(self.company?.employees ?? [])
        
        self.addEmployeeButton.rx.controlEvent([.touchUpInside]).bind { [weak self] in
            guard let self = self else { return }
            let employeeFormViewController = EmployeeFormViewController.instantiate()
            employeeFormViewController.companyEmail = self.company?.companyEmail ?? .empty
            self.navigationController?.pushViewController(employeeFormViewController, animated: true)
        }.disposed(by: viewModel.disposebag)
        
        self.tableView.rx.modelSelected(EmployeeModel.self).subscribe(onNext: { [weak self] emplyoee in
            guard let self = self else { return }
            let employeeFormViewController = EmployeeFormViewController.instantiate()
            employeeFormViewController.employee = emplyoee
            employeeFormViewController.companyEmail = self.company?.companyEmail ?? .empty
            self.navigationController?.pushViewController(employeeFormViewController, animated: true)
        }).disposed(by: viewModel.disposebag)
    }

}
