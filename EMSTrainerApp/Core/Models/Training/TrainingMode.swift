//
//  TrainingMode.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

struct TrainingMode: Codable {
    var name: String
    var description: String
    var length: Int
    var values: ChannelData
}
