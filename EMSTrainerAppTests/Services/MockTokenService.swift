//
//  MockTokenService.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import Foundation

@testable import EMSTrainerApp
class MockTokenService: TokenService {
    private var tokenValue: String?
    var token: String? {
        get {tokenValue}
        set {
            tokenValue = newValue
        }
    }
}
