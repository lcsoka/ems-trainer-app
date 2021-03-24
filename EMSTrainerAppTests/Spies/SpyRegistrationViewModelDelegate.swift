//
//  SpyRegistrationViewModelDelegate.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import XCTest
@testable import EMSTrainerApp

class SpyRegistrationViewModelDelegate: RegistrationViewModelDelegate {
    
    var didCallSuccessfulRegistration: Bool = false
    var successfulRegistrationExpectation: XCTestExpectation?
    
    var didCallErrorRegistration: Bool = false
    var errorRegistrationExpectation: XCTestExpectation?
    
    func onSuccessfulRegistration() {
        guard let expectation = successfulRegistrationExpectation else {
              XCTFail("SpyRegistrationViewModelDelegate was not setup correctly. Missing XCTExpectation reference")
              return
            }
        didCallSuccessfulRegistration = true
        expectation.fulfill()
    }
    
    func onErrorRegistration(error: AppError) {
        guard let expectation = errorRegistrationExpectation else {
              XCTFail("SpyRegistrationViewModelDelegate was not setup correctly. Missing XCTExpectation reference")
              return
            }
        didCallErrorRegistration = true
        expectation.fulfill()
    }
}
