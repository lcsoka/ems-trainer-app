//
//  NetworkEngineMock.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
@testable import EMSTrainerApp

class NetworkEngineMock: NetworkEngine {
    typealias Handler = NetworkEngine.Handler
    
    func performRequest(with: URLRequest, completionHandler: @escaping Handler) {
        completionHandler(
    }
}
