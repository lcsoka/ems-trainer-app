//
//  MockTask.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

class MockTask: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
