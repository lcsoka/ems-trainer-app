//
//  Api.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

class Api {
    
    static let shared = Api()
    
    static let url = "http://localhost:8000/api"
    
    func get<T:ApiResource>(_ resource: T, params: Data?, onSuccess handleSuccess: @escaping(_ response:T.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void) {
        let request = ApiRequest(resource: resource)
        request.load(httpMethod: "GET", body: params,  onSuccess: handleSuccess, onError: handleFailure)
    }
    
    func post<T:ApiResource,E:Encodable>(_ resource: T, data: E?, onSuccess handleSuccess: @escaping(_ response:T.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void) {
        let jsonData = try! JSONEncoder().encode(data)
        let request = ApiRequest(resource: resource)
        request.load(httpMethod: "POST", body: jsonData, onSuccess: handleSuccess, onError: handleFailure)
    }
}
