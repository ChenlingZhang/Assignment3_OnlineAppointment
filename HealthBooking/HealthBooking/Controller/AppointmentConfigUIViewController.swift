//
//  AppointmentConfigUIViewController.swift
//  HealthBooking
//
//  Created by Chenling Zhang on 10/5/2023.
//

import Foundation
import UIKit
import ObjectiveC

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
    var selectedButtons:[ButtonInfo] = []
    var appointmentIDs: [AppointmentID] = []
    var tableCloumn = 0
    var tableCell = 0
    var count = 0
    
    override func viewDidLoad() {
        doctorView.image = img
        doctorName.text = name
        selectedButtons = readButtonInfo()
        appointmentIDs = readAppointmentID()
        navigationBarSetting()
        bindAction()
    }
    
    func navigationBarSetting(){
        navigation.title = "Appointment"
        navigation.backBarButtonItem?.isHidden = true
    }
    
    func bindAction(){
        for case let stacks as UIStackView in timeTable.subviews {
            if stacks.axis == .vertical {
                for subview in stacks.subviews{
                    if let button = subview as? UIButton {
                        // set button's identify
                        button.cloumnId = tableCloumn
                        button.rowId = tableCell
                        // set button action
                        button.addTarget(self, action: #selector(onclick), for: .touchUpInside)
                        
                        // diable selceted buttons
                        var buttonInfo = ButtonInfo(column: button.cloumnId,row: button.rowId, doctorName: name!)
                        
                        if selectedButtons.contains(buttonInfo){
                            button.isEnabled = false
                        }
                        tableCell += 1
                    }
                    tableCloumn += 1
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
    
    func generateAppointmentID() -> String{
        let count = selectedButtons.count
        var id = ""
        
        if count < 10 {
            id = "000\(count)"
        }
        else if (count >= 10) && (count < 100) {
            id = "00\(count)"
        }
        else if (count >= 100) && (count < 1000) {
            id = "0\(count)"
        }
        else {
            id = "\(count)"
        }
        let appointmentId = AppointmentID(appointmentID: id)
        appointmentIDs.append(appointmentId)
        
        return id
    }
    
    func saveButtonInfo(){
        userDefault.set(try? PropertyListEncoder().encode(selectedButtons), forKey: "selectButtons")
    }
    
    func saveAppointmentID(){
        userDefault.set(try? PropertyListEncoder().encode(appointmentIDs), forKey: "appointments")
    }
    
    func readButtonInfo() -> [ButtonInfo]{
        if let saveData = userDefault.value(forKey: "selectButtons") as? Data {
            if let savedButtonInfo = try? PropertyListDecoder().decode(Array<ButtonInfo>.self, from: saveData){
                return savedButtonInfo
            }
        }
        return []
    }
    
    func readAppointmentID() -> [AppointmentID]{
        if let saveData = userDefault.value(forKey: "appointments") as? Data {
            if let savedAppointmentIDs = try? PropertyListDecoder().decode(Array<AppointmentID>.self, from: saveData){
                return savedAppointmentIDs
            }
        }
        return []
    }
    
    @IBAction func backOnclick(_ sender: UIButton) {
        let id1 = selectedButton?.cloumnId
        let id2 = selectedButton?.rowId
        let buttonInfo = ButtonInfo(column: id1,row: id2, doctorName: name!)

        if (buttonInfo.column != nil) && (buttonInfo.row != nil) {
            selectedButtons.append(buttonInfo)
            let message = generateAppointmentID()
            saveButtonInfo()
            saveAppointmentID()
            showAlert(title: "Your Appointment ID", message: message)
        }
        else {
            showAlert(title: "Your Appointment ID", message: "No Appointment")
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
                self?.refreshPage()
            }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func refreshPage() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
            navigationController.topViewController?.viewWillAppear(false)
        } else {
            viewWillAppear(false)
        }
    }
}

private var cloumnKey: Int = 0
private var rowKey: Int = 0

extension UIButton {
    var cloumnId: Int? {
        get {
            return objc_getAssociatedObject(self, &cloumnKey) as? Int
        }
        
        set {
            objc_setAssociatedObject(self, &cloumnKey, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    var rowId: Int? {
        get {
            return objc_getAssociatedObject(self, &rowKey) as? Int
        }
        
        set {
            objc_setAssociatedObject(self, &rowKey, newValue,.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
}

struct ButtonInfo: Codable, Comparable {
    static func < (lhs: ButtonInfo, rhs: ButtonInfo) -> Bool {
        if (lhs.column == rhs.column) && (lhs.row == rhs.row) && (lhs.doctorName == rhs.doctorName){
            return true
        }
        return false
    }
    
    var column: Int?
    var row: Int?
    var doctorName: String
}

struct AppointmentID: Codable {
    var appointmentID: String
}
