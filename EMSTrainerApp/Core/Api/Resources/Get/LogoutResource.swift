//
//  LogoutResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

struct LogoutResource: ApiResource {
    var customUrl: String?
    
    typealias ModelType = EmptyResponse
    let methodPath = "/logout"
}
