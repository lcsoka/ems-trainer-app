//
//  Converter.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 27..
//

import Foundation

class Converter {
    public static func percentToValue(percent: Float, minimum: Float, maximum: Float, jump: Float) -> Float {
        return max(min(round(((percent * (maximum - minimum)) / 100 + minimum) / jump) * jump, maximum),minimum)
    }
    
    public static func valueToPercent(value: Float, minimum: Float, maximum: Float) -> Float {
        return (value - minimum) / (maximum - minimum) * 100
    }
    
    public static func secondsToTimeString(_ time: Int) -> String {
        let mins = time / 60
        let secs = time % 60
        let minsStr: String = mins < 10 ? "0\(mins)" : "\(mins)"
        let secsStr: String = secs < 10 ? "0\(secs)" : "\(secs)"
        return "\(minsStr):\(secsStr)"
    }
}
