//
//  AppointmentUIViewController.swift
//  HealthBooking
//
//  Created by Chenling Zhang on 10/5/2023.
//

import Foundation
import UIKit

class AppointmentUIViewController: UIViewController{
    
    @IBOutlet weak var doctorName01: UILabel!
    @IBOutlet weak var doctorName02: UILabel!
    @IBOutlet weak var doctorName03: UILabel!
    
    @IBOutlet weak var doctorImg01: UIImageView!
    @IBOutlet weak var doctorImg02: UIImageView!
    @IBOutlet weak var doctorImg03: UIImageView!
    
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet var mainUIView: UIView!
    @IBOutlet weak var sideBarView: UIView!
    
    
    var isSideBarVisible = false
    let viewController = ViewController()
    
    override func viewDidLoad() {
        navigationBarSetting()
        initSideBarSetting()
    }
    
    func navigationBarSetting(){
        navigation.title = "Home"
        navigation.hidesBackButton = true
        navigation.rightBarButtonItem = createMenuButton()
    }
    
    func createMenuButton() -> UIBarButtonItem{
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(toggleSideMenu))
        
        return menuButton
    }
    
    func initSideBarSetting(){
        sideBarView.frame = CGRect(x: -sideBarView.frame.width, y: 0, width: sideBarView.frame.width, height: sideBarView.frame.height)
    }
    
    func showSideBar(){
        UIView.animate(withDuration: 0.3) {self.sideBarView.frame.origin.x = 0}
        sideBarView.isHidden = false
        isSideBarVisible = true
    }
    
    func hideSideBar(){
        UIView.animate(withDuration: 0.3) {self.sideBarView.frame.origin.x = -self.sideBarView.frame.width}
        isSideBarVisible = false
    }
    
    @objc func toggleSideMenu(){
        if isSideBarVisible {
            hideSideBar()
        }
        else {
            showSideBar()
        }
    }
    
    @IBAction func logOutButtonOnClick(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? AppointmentConfigUIViewController {
            
            if segue.identifier == "booking01" {
                destinationController.name = doctorName01.text
                destinationController.img = doctorImg01.image!
            }
            else if segue.identifier == "booking02" {
                destinationController.name = doctorName02.text
                destinationController.img = doctorImg02.image!
            }
            else if segue.identifier == "booking03" {
                destinationController.name = doctorName03.text
                destinationController.img = doctorImg03.image!
            }
        }
    }
}
