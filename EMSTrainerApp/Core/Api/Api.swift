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
    
    func get<T:ApiResource>(_ resource: T, params: Data?, withCompletion completion: @escaping(_ response:T.ModelType?) -> Void) {
        let request = ApiRequest(resource: resource)
        request.load(httpMethod: "GET", body: params, withCompletion: completion)
    }
    
    func post() {
        
    }
}
