//
//  ApiRequest.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

class ApiRequest<Resource: ApiResource> {
    
    let resource: Resource

    let httpHeaders: [String:String] = [
        "Accept":"application/json",
        "Content-Type":"application/json",
//        "Authorization":"Bearer 5|Ay9ShYY2h44EHCu4eDnjRnIqN5OP1Jjdzl5B5tOn"
    ]
    
    init(resource: Resource) {
        self.resource = resource
    }
    
}

extension ApiRequest: NetworkRequest {
    
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
