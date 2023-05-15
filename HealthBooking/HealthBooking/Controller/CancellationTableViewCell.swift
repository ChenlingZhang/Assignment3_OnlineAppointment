//
//  CancellationTableViewCell.swift
//  HealthBooking
//
//  Created by jiaxing on 16/5/2023.
//

import UIKit

class CancellationTableViewCell: UITableViewCell {

    @IBOutlet weak var appointmentIDLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    @IBAction func deleteButtonClicked(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
