//
//  Int.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 08..
//

import Foundation

extension Int {
    func toTimeString() ->  String{
        let hours = self / 3600
        let mins = (self % 3600) / 60
        let secs = (self % 3600) % 60
        
        let hoursString = hours > 0 ? "\(hours)h " : ""
        let minsString = "\(mins)m "
        let secsString = secs > 0 ? "\(secs)s" : ""
        
        return "\(hoursString)\(minsString)\(secsString)"
    }
}
