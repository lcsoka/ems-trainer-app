//
//  FinderViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 17..
//

import Foundation

protocol FinderViewModelDelegate {
    func onDeviceListRefresh()
}

class FinderViewModel {
    var finderViewModelDelegate: FinderViewModelDelegate?
    
    var searching: Bool = false
    var finder: FinderProtocol! {
        didSet {
            finder.delegate = self
        }
    }
    var devices: [String:DeviceRow] = [:]
    var selectedDevice: DeviceHost?
    
    
    func startSearch() {
        searching = true
        search()
    }
    
    func stopSearch() {
        searching = false
        finder.stop()
    }
    
    private func search() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if self.searching {
                self.search()
            }
        }
        resetDeviceList()
        finder.start()
    }
    
    private func resetDeviceList() {
        // Set all device row's found to false
        // If TTL is greater than 0 then subtract one, if TTL is 0 then remove row
        devices.keys.forEach { devices[$0]!.found = false; devices[$0]!.ttl > 0 ? devices[$0]!.ttl-=1 : removeDevice(for: $0)}
    }
    
    private func removeNotFoundDevices() {
        let notFound = self.devices.filter { !$0.value.found }
        for disappeared in notFound {
            self.removeDevice(for: disappeared.key)
        }
        finderViewModelDelegate?.onDeviceListRefresh()
    }
    
    private func removeDevice(for key: String) {
        devices.removeValue(forKey: key)
        finderViewModelDelegate?.onDeviceListRefresh()
    }
}

extension FinderViewModel: FinderDelegate {
    func onDeviceFound(device: DeviceHost) {
        let address = device.address
        devices[address] = DeviceRow(found: true, ttl: 1, host: device)
        if selectedDevice?.address == address {
            selectedDevice = device
        }
        finderViewModelDelegate?.onDeviceListRefresh()
    }
    
    func onFinderStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeNotFoundDevices()
        }
    }
}
