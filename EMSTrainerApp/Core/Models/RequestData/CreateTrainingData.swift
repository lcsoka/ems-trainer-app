//
//  CreateTrainingData.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 18..
//

import Foundation

struct CreateTrainingData: Encodable {
    var length: Int
    var trainingMode: String
    var trainingValues: [TrainingValueJSON]
    var date: Int
    
    enum CodingKeys: String, CodingKey {
        case length, date
        case trainingMode = "training_mode"
        case trainingValues = "training_values"
    }
}
