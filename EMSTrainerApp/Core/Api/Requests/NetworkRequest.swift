//
//  NetworkRequest.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//
import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func load(withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL, httpMethod: String, body: Data?, httpHeaders: [String:String]?, withCompletion completion: @escaping (ModelType?) -> Void) {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = httpFields
        let task = session.dataTask(with: urlRequest, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self.decode(data))
        })
        task.resume()
    }
}
