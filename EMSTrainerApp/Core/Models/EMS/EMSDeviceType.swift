//
//  EMSDeviceType.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

protocol EMSDeviceType {
    var serial: String { get set }
    var battery: Int { get set }
    var connected: Bool { get set }
    var elapsed: Int { get set }
    var version: String { get set }
}
