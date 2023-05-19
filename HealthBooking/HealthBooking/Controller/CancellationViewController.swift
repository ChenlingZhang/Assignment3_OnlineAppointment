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
    
    func saveAppointmentIDs() {
        let encoder = PropertyListEncoder()
        if let encodedData = try? encoder.encode(appointmentIDs) {
            userDefault.set(encodedData, forKey: "appointments")
        }
        tableView.reloadData()
    }
    
    func deleteAppointment(at index: Int) {
        if index < 0 || index >= appointmentIDs.count {
            return
        }
        appointmentIDs.remove(at: index)
        saveAppointmentIDs()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: tableView.bounds.width - 32, height: 30))
        label.text = "AppointmentID"
        // 自定义 label 的样式，如字体、颜色等
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag

           let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this appointment?", preferredStyle: .alert)
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           
           let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
               self?.deleteAppointment(at: index)
           }
           
           alertController.addAction(cancelAction)
           alertController.addAction(deleteAction)
           
           present(alertController, animated: true, completion: nil)
    }
    
    
}
