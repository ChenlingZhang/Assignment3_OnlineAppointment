//
//  AppointmentConfigUIViewController.swift
//  HealthBooking
//
//  Created by Chenling Zhang on 10/5/2023.
//

import Foundation
import UIKit

class AppointmentConfigUIViewController: UIViewController {
    
    @IBOutlet weak var doctorView: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var timeTable: UIStackView!
    
    let userDefault = UserDefaults.standard
    
    var name: String?
    var img: UIImage?
    var date: String?
    var time: String?
    var isGetDate = false
    var selectedButton: UIButton?
    var selectedButtons:[UIButton] = []
    var appointmentIDs: [String] = []
    
    override func viewDidLoad() {
        doctorView.image = img
        doctorName.text = name
        navigationBarSetting()
        bindAction()
        selectedButtons = readData()
    }
    
    func navigationBarSetting(){
        navigation.title = "Appointment"
        navigation.hidesBackButton = true
    }
    
    func bindAction(){
        for case let stacks as UIStackView in timeTable.subviews {
            if stacks.axis == .vertical {
                for subview in stacks.subviews{
                    if let button = subview as? UIButton {
                        button.addTarget(self, action: #selector(onclick), for: .touchUpInside)
                        if selectedButtons.contains(button){
                            button.isEnabled = false
                        }
                    }
                }
            }
        }
    }
    
    @objc func onclick(_ sender: UIButton){
        if sender.isSelected == true {
            isGetDate = false
            sender.isSelected = false
            self.date = ""
            time = ""
            return
        }
        selectedButton?.isSelected = false
        time = sender.titleLabel?.text
        sender.isSelected = true
        selectedButton = sender
        isGetDate = true
    }
    
    @IBAction func backOnclick(_ sender: UIButton) {
        let appointmentID = saveData()
        showAlert(title: "Your ID", message: appointmentID)
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func saveData() -> String{
        if selectedButton != nil {
            
            selectedButtons.append(selectedButton!)
            if let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: selectedButtons, requiringSecureCoding: false){
                userDefault.set(selectedButtons, forKey: "appointment")
            }
            
            if selectedButtons.count < 10 {
                appointmentIDs.append("000\(selectedButtons.count)")
            }
            else if (selectedButtons.count >= 10) && (selectedButtons.count < 100) {
                appointmentIDs.append("00\(selectedButtons.count)")
            }
            else if (selectedButtons.count >= 100) && (selectedButtons.count < 1000) {
                appointmentIDs.append("0\(selectedButtons.count)")
            }
            else {
                appointmentIDs.append("\(selectedButtons.count)")
            }
            userDefault.set(appointmentIDs, forKey: "appointmentID")
        }
        return appointmentIDs[appointmentIDs.count-1]
    }
    
    func readData() -> [UIButton]{
        if let savedButtonsData = userDefault.object(forKey: "appointment") as? Data {
            if let selectedButtons = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, UIButton.self], from: savedButtonsData) as? [UIButton] {
                    return selectedButtons
                }
        }
        return []
    }
}
