//
//  RegisterResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

struct RegisterResource: ApiResource {
    var customUrl: String?
    
    typealias ModelType = UserResponse
    let methodPath = "/auth/register"
}
