//
//  EMSValues.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

class EMSValues: Codable, EMSChannel {
    var value: Int
    var freq: Int
    var time: Int
    var pause: Int
}
