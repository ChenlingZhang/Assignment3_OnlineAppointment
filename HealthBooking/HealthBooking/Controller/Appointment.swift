//
//  Appointment.swift
//  HealthBooking
//
//  Created by Chenling Zhang on 10/5/2023.
//

import Foundation

class appointment{
    var day: String
    var time: String
    var id: String
    
    init(day: String, time: String, id: String) {
        self.day = day
        self.time = time
        self.id = id
    }
}
