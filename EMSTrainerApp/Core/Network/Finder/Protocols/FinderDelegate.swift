//
//  FinderDelegate.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import Foundation

protocol FinderDelegate {
    func onDeviceFound(device: DeviceHost)
    func onFinderStopped()
}
