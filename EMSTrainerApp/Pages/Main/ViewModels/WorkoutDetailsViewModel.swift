//
//  WorkoutDetailsViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 24..
//

import Foundation

class WorkoutDetailsViewModel {
    var workout: Training!
    
    var trainingValues: [TrainingValue] {
        get {
            var values = workout.trainingValues?.allObjects as! [TrainingValue]
            values.sort(by: {$0.timestamp < $1.timestamp})
            return values
        }
    }
}
