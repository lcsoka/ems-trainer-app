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
    var host: DeviceHost
}

final class WorkoutSetupViewModel {
    
    let trainingModes: [TrainingMode]
    var delegate: WorkoutSetupViewModelDelegate?
    
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
    
    func search() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.search()
        }
        resetDeviceList()
        finder.start()
    }
    
    func stopSearch() {
        finder.stop()
    }
    
    func canStartWorkout() -> Bool {
        return selectedMode != nil && selectedDevice != nil
    }
    
    private func resetDeviceList() {
        devices.keys.forEach { devices[$0]!.found = false}
    }
}

extension WorkoutSetupViewModel: FinderDelegate {
    func onDeviceFound(device: DeviceHost) {
        let address = device.address
        devices[address] = DeviceRow(found: true, host: device)
        delegate?.onDeviceListRefresh()
    }
    
    func onFinderStopped() {
        let notFound = devices.filter { !$0.value.found }
        for disappeared in notFound {
            devices.removeValue(forKey: disappeared.key)
        }
        delegate?.onDeviceListRefresh()
    }
}
