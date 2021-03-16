//
//  DeviceStatusResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

struct DeviceStatusResource: ApiResource {
    typealias ModelType = DeviceStatusResponse
    var customUrl: String?
    let methodPath = "/status"
    init(host: String) {
        self.customUrl = host
    }
}
