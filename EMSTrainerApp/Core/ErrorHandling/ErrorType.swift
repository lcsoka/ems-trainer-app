//
//  ApiErrorType.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 19..
//

import Foundation

enum ErrorType {
    case api
    case unauthorized
    case validation
    case server
    case timeout
    case decode
    case unknown
}
