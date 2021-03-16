//
//  WorkoutSetupViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

final class WorkoutSetupViewModel {
    
    let trainingModes: [TrainingMode]
    
    init() {
        let jsonData = Bundle.main.loadFile(filename: "TrainingModes.json")!
        trainingModes = try! JSONDecoder().decode([TrainingMode].self, from: jsonData)
    }
}
