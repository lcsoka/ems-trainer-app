//
//  TrainingValueJSON.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 07..
//

import Foundation

struct TrainingValueJSON: Codable, DictionaryConvertable {
    var timestamp: Int
    var master: Int
}
