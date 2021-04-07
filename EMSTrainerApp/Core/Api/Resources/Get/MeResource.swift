//
//  MeResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

struct MeResource: ApiResource {
    var customUrl: String?
    
    typealias ModelType = MeResponse
    let methodPath = "/me"
}
