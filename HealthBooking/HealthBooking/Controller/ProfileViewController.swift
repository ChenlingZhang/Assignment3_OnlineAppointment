//
//  ProfileViewController.swift
//  HealthBooking
//
//  Created by fan on 16/5/2023.
//

import Foundation
import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    @IBOutlet weak var mobTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var userData: [String: String]?
    var userEmail: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
    }
    
    // This function retrieves the user's data from UserDefaults.
    func loadUserData() {
        userEmail = UserDefaults.standard.string(forKey: "currentUserEmail")
        if let userEmail = userEmail {
            userData = UserDefaults.standard.dictionary(forKey: userEmail) as? [String: String]
            firstNameTextField.text = userData?["firstName"]
            lastNameTextField.text = userData?["lastName"]
            mobTextField.text = userData?["mob"]
            emailTextField.text = userEmail
            
            // Create a date formatter and format the date from the userData, then set it to the date picker.
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            if let dob = userData?["dateOfBirth"], let date = dateFormatter.date(from: dob) {
                dateOfBirthPicker.date = date
            }
        }
    }
    
    // This function is linked to the 'Confirm' button, it will navigate back to the previous view controller when tapped.
    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // This function is linked to the 'Edit' button, it will save the updated user data when tapped.
    @IBAction func editButtonTapped(_ sender: Any) {
        if let firstName = firstNameTextField.text, !firstName.isEmpty,
           let lastName = lastNameTextField.text, !lastName.isEmpty,
           let mob = mobTextField.text, !mob.isEmpty,
           let email = emailTextField.text, !email.isEmpty,
           let userEmail = userEmail {
            
            // Format the date and save all the new data into UserDefaults.
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let dateOfBirth = dateFormatter.string(from: dateOfBirthPicker.date)
            
            let newUserData: [String: String] = [
                "firstName": firstName,
                "lastName": lastName,
                "dateOfBirth": dateOfBirth,
                "mob": mob,
                "email": email,
                "password": userData?["password"] ?? ""
            ]
            
            UserDefaults.standard.setValue(newUserData, forKey: userEmail)
        } else {
            showAlert(title: "Error", message: "Please fill in all the fields.")
        }
    }
    
    // This function creates and presents an alert controller with a provided title and message.
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
