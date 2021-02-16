//
//  LoginResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 17..
//

import Foundation

struct LoginResource: ApiResource {
    typealias ModelType = UserResponse
    let methodPath = "/auth/login"
}
