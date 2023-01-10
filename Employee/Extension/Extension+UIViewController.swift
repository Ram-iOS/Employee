//
//  Extension+UIViewController.swift
//  Employee
//
//  Created by Rameshwar Kumavat on 10/01/23.
//

import UIKit

extension UIViewController {
    
    static func instantiate() -> Self {
        let name = String(describing: self).replacingOccurrences(of: "ViewController", with: "")
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        guard let controller = initial as? Self else {
            fatalError("Check Storyboard for: \(name)")
        }
        return controller
    }
}
