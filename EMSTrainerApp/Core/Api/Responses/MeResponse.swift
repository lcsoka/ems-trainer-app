//
//  MeResponse.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 07..
//

import Foundation

struct MeResponse: Codable {
    var user: User
    var trainings: [TrainingJSON]
}
