//
//  ApiRequest.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

class ApiRequest<Resource: ApiResource> {
    
    let resource: Resource
    private let engine: NetworkEngine

    var httpHeaders: [String:String] = [
        "Accept":"application/json",
        "Content-Type":"application/json",
    ]
    
    init(resource: Resource, tokenService: TokenService, engine: NetworkEngine = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)) {
        self.resource = resource
        self.engine = engine
        
        if let token = tokenService.token {
            httpHeaders["Authorization"] = "Bearer \(token)"
        }
    }    
}

extension ApiRequest: NetworkRequest {
    
    func getEngine() -> NetworkEngine {
        return engine
    }
    
    func decode(_ data: Data) -> Resource.ModelType? {
        let response = try? JSONDecoder().decode(ApiResponse<Resource.ModelType>.self, from: data)
        return response?.data
    }
    
    func decodeError(_ error: Data) -> [ApiErrorResponse.ApiError]? {
        let response = try? JSONDecoder().decode(ApiErrorResponse.self, from: error)
        return response?.errors
    }
    
    func load(onSuccess handleSuccess: @escaping (Resource.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void) {
        load(resource.url,httpMethod: "GET",body: nil,httpHeaders: httpHeaders, onSuccess: handleSuccess, onError: handleFailure)
    }
    
    func load(httpMethod: String, body: Data?, onSuccess handleSuccess: @escaping (Resource.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void) {
        load(resource.url,httpMethod: httpMethod,body: body,httpHeaders: httpHeaders, onSuccess: handleSuccess, onError: handleFailure)
    }
    
}
