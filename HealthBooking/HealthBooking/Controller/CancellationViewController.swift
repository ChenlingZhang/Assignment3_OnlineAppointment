//
//  CancellationViewController.swift
//  HealthBooking
//
//  Created by jiaxing on 14/5/2023.
//

import Foundation
import UIKit
import ObjectiveC

class CancellationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
    
    @IBOutlet weak var tableView: UITableView!
 
    let userDefault = UserDefaults.standard
    let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
    var appointmentIDs: [AppointmentID] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        appointmentIDs = readCurrentUserAppointmentIDs()
        tableView.reloadData()
    }
    
    ///---data---
    
    // Read all appointment IDs
    func readAllAppointmentIDs() -> [AppointmentID] {
        // Retrieve saved data from UserDefaults
        if let saveData = userDefault.value(forKey: "appointments") as? Data {
            // Decode the data into an array of AppointmentID
            if let savedAppointmentIDs = try? PropertyListDecoder().decode([AppointmentID].self, from: saveData) {
                return savedAppointmentIDs
            }
        }
        // Return an empty array if decoding fails or no saved data exists
        return []
    }

    // Read appointment IDs for the current user
    func readCurrentUserAppointmentIDs() -> [AppointmentID] {
        let allAppointmentIDs = readAllAppointmentIDs()
        // Filter appointment IDs for the current user
        return allAppointmentIDs.filter { $0.userEmail == currentUserEmail }
    }

    // Save appointment IDs
    func saveAppointmentIDs() {
        let encoder = PropertyListEncoder()
        if let encodedData = try? encoder.encode(appointmentIDs) {
            // Save the encoded data to UserDefaults
            userDefault.set(encodedData, forKey: "appointments")
            // Reload the table view to reflect the changes
            tableView.reloadData()
        }
    }

    // Delete an appointment
    func deleteAppointment(at index: Int) {
        // Check if the index is within the valid range
        if appointmentIDs.indices.contains(index) {
            // Remove the appointment ID at the given index from the array
            appointmentIDs.remove(at: index)
            // Save the updated appointment IDs and reload the table view
            saveAppointmentIDs()
        }
    }

    
    /// ---Table View Setting---
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows based on the appointmentIDs count
        return appointmentIDs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the reusable cell and cast it to CancellationCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CancellationCell", for: indexPath) as? CancellationCell else {
            fatalError("The dequeued cell is not an instance of CancellationCell.")
        }
        
        // Retrieve the appointment at the current index path
        let appointment = appointmentIDs[indexPath.row]
        
        // Configure the cell with the appointment data
        cell.appointmentIDLabel.text = appointment.appointmentID
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Create a custom view for the table view header
        let headerView = UIView()
        
        // Create a label and configure its frame and text
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.width - 32, height: 30))
        label.text = "AppointmentID"
        
        // Add the label to the header view
        headerView.addSubview(label)
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Return the desired height for the table view header
        return 30
    }


    /// --- UI---
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        // Retrieve the index from the button's tag
        let index = sender.tag

        // Create an alert controller to confirm the deletion
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this appointment?", preferredStyle: .alert)

        // Create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        // Create a delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            // Call the deleteAppointment method when delete is confirmed
            self?.deleteAppointment(at: index)
        }

        // Add actions to the alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
}
