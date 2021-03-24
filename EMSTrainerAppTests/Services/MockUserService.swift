//
//  MockUserService.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import Foundation
@testable import EMSTrainerApp

class MockUserService: UserService {
    private var user: User?
    var currentUser: User? {
        get {user}
        set {
            user = newValue
            
        }
    }
}
