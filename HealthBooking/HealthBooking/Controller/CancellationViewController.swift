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
  
    
    
    let userDefault = UserDefaults.standard
    let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
    var appointmentIDs: [AppointmentID] = []
    
    @IBAction func pressedBtnConfirm(_ sender: Any) {
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        appointmentIDs = readCurrentUserAppointmentIDs()
        tableView.reloadData()
    }
    
    func readAllAppointmentIDs() -> [AppointmentID]{
        if let saveData = userDefault.value(forKey: "appointments") as? Data {
            if let savedAppointmentIDs = try? PropertyListDecoder().decode(Array<AppointmentID>.self, from: saveData){
                return savedAppointmentIDs
            }
        }
        return []
    }
    
    func readCurrentUserAppointmentIDs() -> [AppointmentID] {
        let allAppointmentIDs = readAllAppointmentIDs()
        return allAppointmentIDs.filter { $0.userEmail == currentUserEmail }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentIDs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CancellationCell", for: indexPath) as? CancellationCell else {
            fatalError("The dequeued cell is not an instance of CancellationCell.")
        }
        let appointment = appointmentIDs[indexPath.row]
        cell.appointmentIDLabel.text = appointment.appointmentID
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        appointmentIDs.remove(at: index)
        tableView.reloadData()
    }
}
