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

final class WorkoutSetupViewModel: FinderViewModel {
    
    let trainingModes: [TrainingMode]
    var delegate: WorkoutSetupViewModelDelegate?
    
    var selectedMode: TrainingMode? {
        didSet {
            delegate?.onDataChange()
        }
    }
    
    override var selectedDevice: DeviceHost? {
        didSet {
            delegate?.onDataChange()
        }
    }
    
    init(api: ApiService) {
        let jsonData = Bundle.main.loadFile(filename: "TrainingModes.json")!
        trainingModes = try! JSONDecoder().decode([TrainingMode].self, from: jsonData)
    }
    
    func canStartWorkout() -> Bool {
        return selectedMode != nil && selectedDevice != nil
    }

}
