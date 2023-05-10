//
//  RegisterViewController.swift
//  HealthBooking
//
//  Created by Zhiyi He on 9/5/2023.
//

import UIKit
import Foundation

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    @IBOutlet weak var mobTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        if let firstName = firstNameTextField.text, !firstName.isEmpty,
           let lastName = lastNameTextField.text, !lastName.isEmpty,
           let mob = mobTextField.text, !mob.isEmpty,
           let email = emailTextField.text, !email.isEmpty,
           let password = passwordTextField.text, !password.isEmpty {
            
            if !email.contains("@") {
                showAlert(title: "Error", message: "Please provide a valid email address.")
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let dateOfBirth = dateFormatter.string(from: dateOfBirthPicker.date)
            
            let userData: [String: String] = [
                "firstName": firstName,
                "lastName": lastName,
                "dateOfBirth": dateOfBirth,
                "mob": mob,
                "email": email,
                "password": password
            ]
            
            UserDefaults.standard.setValue(userData, forKey: email)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            showAlert(title: "Error", message: "Please fill in all the fields.")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

