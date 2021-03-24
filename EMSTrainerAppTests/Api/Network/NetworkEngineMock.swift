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
    
    var data: Data?
    var statusCode = 200
    var error: Error?
    
    var urlRequest: URLRequest!
    
    func performRequest(with: URLRequest, completionHandler: @escaping Handler) {
        urlRequest = with
        let urlResponse = HTTPURLResponse(url: with.url!, statusCode: statusCode, httpVersion: "1.1", headerFields: nil)
        completionHandler(data, urlResponse, error)
    }
}
