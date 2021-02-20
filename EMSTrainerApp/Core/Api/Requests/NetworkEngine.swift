//
//  NetworkEngine.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

protocol NetworkEngine {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    func performRequest(with: URLRequest, completionHandler: @escaping Handler)
}

extension URLSession: NetworkEngine {
    typealias Handler = NetworkEngine.Handler

    func performRequest(with: URLRequest, completionHandler: @escaping Handler) {
        let task = dataTask(with: with, completionHandler: completionHandler)
        task.resume()
    }

}
