//
//  FormViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 21..
//

import Foundation

struct BrokenRule {
    var propertyName :String
    var message :String
}


protocol FormViewModel {
    var brokenRules :[BrokenRule] { get set}
    var isValid :Bool { mutating get }
}
