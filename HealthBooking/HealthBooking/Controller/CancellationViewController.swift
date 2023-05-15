//
//  CancellationViewController.swift
//  HealthBooking
//
//  Created by jiaxing on 16/5/2023.
//

import Foundation
import UIKit

class CancellationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let currentEmail = UserDefaults.standard.string(forKey: "currentUserEmail")
    
    let userDefault = UserDefaults.standard
    var appointmentIDs: [AppointmentID] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        appointmentIDs = readAppointmentID()
    }
    
    func readAppointmentID() -> [AppointmentID]{
        if let saveData = userDefault.value(forKey: "appointments") as? Data {
            if let savedAppointmentIDs = try? PropertyListDecoder().decode(Array<AppointmentID>.self, from: saveData){
                return savedAppointmentIDs
            }
        }
        return []
    }
    
    // MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentIDs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancellationCell", for: indexPath) as! CancellationTableViewCell
        let appointmentID = appointmentIDs[indexPath.row]
        //cell.appointmentIDLabel.text = appointmentID.id
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    // Add any delegate methods if needed
    
    // MARK: - Action Methods
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let appointmentID = appointmentIDs[sender.tag]
        //deleteAppointmentID(id: appointmentID.id)
        appointmentIDs.remove(at: sender.tag)
        tableView.reloadData()
    }
    
    func deleteAppointmentID(id: String) {
        if let savedData = UserDefaults.standard.value(forKey: "appointments") as? Data {
            if var savedAppointmentIDs = try? PropertyListDecoder().decode(Array<AppointmentID>.self, from: savedData) {
                //ssavedAppointmentIDs.removeAll(where: { $0.id == id })
                if let saveData = try? PropertyListEncoder().encode(savedAppointmentIDs) {
                    UserDefaults.standard.set(saveData, forKey: "appointments")
                }
            }
        }
    }
}
