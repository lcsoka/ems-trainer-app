//
//  DeviceHost.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

class DeviceHost: EMSDeviceType, Equatable {
    var serial: String
    
    var battery: Int
    
    var connected: Bool
    
    var elapsed: Int
    
    var version: String
    
    var address: String
    
    init(address: String, deviceStatus: DeviceStatusResponse) {
        self.address = address
        self.serial = deviceStatus.serial
        self.battery = deviceStatus.battery
        self.connected = deviceStatus.connected
        self.elapsed = deviceStatus.elapsed
        self.version = deviceStatus.version
    }
    
    static func == (lhs: DeviceHost, rhs: DeviceHost) -> Bool {
        return lhs.address == rhs.address
    }
}
