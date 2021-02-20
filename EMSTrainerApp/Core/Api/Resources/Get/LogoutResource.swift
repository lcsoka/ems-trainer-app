//
//  LogoutResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

struct LogoutResource: ApiResource {
    typealias ModelType = EmptyResponse
    let methodPath = "/logout"
}
