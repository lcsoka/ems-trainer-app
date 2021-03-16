//
//  EMSMessage.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 17..
//

import Foundation

enum EMSMessage: Int {
    case setMasterValue = 0
    case setChannelValue = 1
    case setChannelFreq = 2
    case setImpulseOn = 3
    case setImpulseOff = 4
    case setImpuleTime = 5
    case setImpulsePause = 6
    case getBattery = 7
}
