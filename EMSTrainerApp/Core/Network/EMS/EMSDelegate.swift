//
//  EMSDelegate.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

protocol EMSDelegate {
    func onConnected()
    
    func onImpulseOn()
    
    func onImpulseOff()
    
    func onBatteryChanged(_ percentage: Int)
}
