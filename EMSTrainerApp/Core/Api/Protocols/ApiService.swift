//
//  ApiService.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation

protocol ApiService {
    func get<T:ApiResource>(_ resource: T, params: Data?, onSuccess handleSuccess: @escaping(_ response:T.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void)
    
    func post<T:ApiResource,E:Encodable>(_ resource: T, data: E?, onSuccess handleSuccess: @escaping(_ response:T.ModelType?) -> Void, onError handleFailure: @escaping (AppError?) -> Void)
}
