//
//  NetworkRequest.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//
import Foundation

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    associatedtype ModelError
    func decode(_ data: Data) -> ModelType?
    func decodeError(_ error: Data) -> ModelError?
    func getEngine() -> NetworkEngine
    func load(onSuccess handleSuccess: @escaping (ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void)
}

extension NetworkRequest {
    func load(_ url: URL, httpMethod: String, body: Data?, httpHeaders: [String:String]?, onSuccess handleSuccess: @escaping (ModelType?) -> Void,onError handleFailure: @escaping (AppError?) -> Void) {
        var urlRequest = URLRequest(url:url)
        urlRequest.httpMethod = httpMethod
        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = httpHeaders
        urlRequest.timeoutInterval = 10
        
        getEngine().performRequest(with: urlRequest, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) ->  Void in
            if let data = data, let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200...299:
                        handleSuccess(self.decode(data))
                    case 400:
                        // Bad api request
                        handleFailure(AppError(code: .api, messages: self.decodeError(data) as! [Any]))
                        break
                    case 401:
                        // Unauthorized
                        handleFailure(AppError(code: .unauthorized, messages: self.decodeError(data) as! [Any]))
//                        Auth.shared.onLogout(true)
                        break
                    case 422:
                        // Unauthorized
                        handleFailure(AppError(code: .validation, messages: self.decodeError(data) as! [Any]))
                        break
                    case 500:
                        // Server error
                        handleFailure(AppError(code: .server, messages: ["Server error."]))
                        break
                    case 501...599:
                        // Unknown error
                        handleFailure(AppError(code: .unknown, messages: ["Unknown server error."]))
                        break
                    default:
                        break
                    }
            }
            if let error = error as NSError?  {
                if error.code == NSURLErrorTimedOut {
                    handleFailure(AppError(code: .timeout, messages: ["Timeout has occoured."]))
                } else {
                    handleFailure(AppError(code: .unknown, messages: ["Unknown error."]))
                }
            }
            guard data != nil else {
                handleFailure(nil)
                return
            }
        })
    }
}
