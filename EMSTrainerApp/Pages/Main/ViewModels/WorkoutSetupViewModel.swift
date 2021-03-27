//
//  WorkoutSetupViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

protocol WorkoutSetupViewModelDelegate {
    func onDataChange()
    func onDeviceListRefresh()
}

struct DeviceRow {
    var found: Bool
    var ttl: Int
    var host: DeviceHost
}

final class WorkoutSetupViewModel {
    
    let trainingModes: [TrainingMode]
    var delegate: WorkoutSetupViewModelDelegate?
    
    private var searching = false
    
    var finder: FinderProtocol! {
        didSet {
            finder.delegate = self
        }
    }
    var devices: [String:DeviceRow] = [:]
    
    var selectedMode: TrainingMode? {
        didSet {
            delegate?.onDataChange()
        }
    }
    
    var selectedDevice: DeviceHost? {
        didSet {
            delegate?.onDataChange()
        }
    }
    init(api: ApiService) {
        let jsonData = Bundle.main.loadFile(filename: "TrainingModes.json")!
        trainingModes = try! JSONDecoder().decode([TrainingMode].self, from: jsonData)
    }
    
    func startSearch() {
        searching = true
        search()
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
    
    func stopSearch() {
        searching = false
        finder.stop()
    }
    
    func canStartWorkout() -> Bool {
        return selectedMode != nil && selectedDevice != nil
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
        delegate?.onDeviceListRefresh()
    }
    
    private func removeDevice(for key: String) {
        devices.removeValue(forKey: key)
        delegate?.onDeviceListRefresh()
    }
}

extension WorkoutSetupViewModel: FinderDelegate {
    func onDeviceFound(device: DeviceHost) {
        let address = device.address
        devices[address] = DeviceRow(found: true, ttl: 1, host: device)
        if selectedDevice?.address == address {
            selectedDevice = device
        }
        delegate?.onDeviceListRefresh()
    }
    
    func onFinderStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.removeNotFoundDevices()
        }
    }
}
