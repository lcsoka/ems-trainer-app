//
//  DeviceApiResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 16..
//

import Foundation

protocol DeviceApiResource: ApiResource {
    var host: String { get set }
    
}
extension DeviceApiResource {
    var url: URL {
        var components = URLComponents(string: host)!
        components.path += methodPath
        return components.url!
    }
}
