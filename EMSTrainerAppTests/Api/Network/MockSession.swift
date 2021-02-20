//
//  MockSession.swift
//  EMSTrainerAppTests
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

class MockSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let response = self.response
        let error = self.error
        return MockTask {
            completionHandler(data, response, error)
        }
    }
}
