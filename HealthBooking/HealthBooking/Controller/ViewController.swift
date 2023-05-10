//
//  ViewController.swift
//  HealthBooking
//
//  Created by Zhiyi He on 3/5/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email and password")
            return
        }

        if isValidEmail(email: email), let savedUserData = UserDefaults.standard.dictionary(forKey: email), savedUserData["password"] as? String == password {
            // login success
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let appointmentVC = storyboard.instantiateViewController(withIdentifier: "AppointmentViewController") as? AppointmentUIViewController {
                self.navigationController?.pushViewController(appointmentVC, animated: true)
            }
        } else {
            // login failed
            showAlert(title: "Error", message: "Sorry, we can't find your account")
        }
    }

    func isValidEmail(email: String) -> Bool {
        return email.contains("@")
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
