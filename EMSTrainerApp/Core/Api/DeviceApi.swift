//
//  DeviceApi.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

class DeviceApi: ApiService {
    private let engine: NetworkEngine
    
    init(engine: NetworkEngine) {
        self.engine = engine
    }
    
    func get<T:ApiResource>(_ resource: T, params: Data?, onSuccess handleSuccess: @escaping(_ response:T.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void) {
        let request = DeviceApiRequest(resource: resource, engine: engine)
        request.load(httpMethod: "GET", body: params,  onSuccess: handleSuccess, onError: handleFailure)
    }
    
    func post<T:ApiResource,E:Encodable>(_ resource: T, data: E?, onSuccess handleSuccess: @escaping(_ response:T.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void) {
        let jsonData = try! JSONEncoder().encode(data)
        let request = DeviceApiRequest(resource: resource, engine: engine)
        request.load(httpMethod: "POST", body: jsonData, onSuccess: handleSuccess, onError: handleFailure)
    }
    
}
