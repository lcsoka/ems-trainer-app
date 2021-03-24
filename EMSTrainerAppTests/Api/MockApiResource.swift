//
//  MockApiResource.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 24..
//

import Foundation

@testable import EMSTrainerApp

struct MockApiResource: ApiResource {
    var customUrl: String?
    typealias ModelType = MockResponse
    let methodPath = "/mock"
}
