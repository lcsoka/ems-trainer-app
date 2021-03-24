//
//  SpyLoginViewModelDelegate.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import XCTest
@testable import EMSTrainerApp

class SpyLoginViewModelDelegate: LoginViewModelDelegate {
    
    var didCallSuccessfulLogin: Bool = false
    var successfulLoginExpectation: XCTestExpectation?
    
    var didCallErrorLogin: Bool = false
    var errorLoginExpectation: XCTestExpectation?
    
    func onSuccessfulLogin() {
        guard let expectation = successfulLoginExpectation else {
              XCTFail("SpyLoginViewModelDelegate was not setup correctly. Missing XCTExpectation reference")
              return
            }
        didCallSuccessfulLogin = true
        expectation.fulfill()
    }
    
    func onErrorLogin(error: AppError) {
        guard let expectation = errorLoginExpectation else {
              XCTFail("SpyLoginViewModelDelegate was not setup correctly. Missing XCTExpectation reference")
              return
            }
        didCallErrorLogin = true
        expectation.fulfill()
    }
}
