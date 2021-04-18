//
//  CreateTrainingResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 18..
//

import Foundation

struct CreateTrainingResource: ApiResource {
    var customUrl: String?
    
    typealias ModelType = TrainingsResponse
    let methodPath = "/training/create"
}
