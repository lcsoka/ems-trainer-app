//
//  DeviceStatusResponse.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

struct DeviceStatusResponse: EMSDeviceType, Codable {
    var serial: String
    var battery: Int
    var connected: Bool
    var elapsed: Int
    var version: String
}
