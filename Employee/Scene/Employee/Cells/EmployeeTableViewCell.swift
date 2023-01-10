//
//  EmployeeTableViewCell.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var departmentLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(withEmployeeModel model: EmployeeModel) {
        self.nameLabel.text = model.name
        self.emailLabel.text = model.email
        self.departmentLabel.text = model.department
        self.statusLabel.text = model.active ? "Active" : "Resigned"
    }
}
