//
//  ApiResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

protocol ApiResource {
    associatedtype ModelType: Codable
    var methodPath: String { get }
}
 
extension ApiResource {
    var url: URL {
        var components = URLComponents(string: AppConfig.API_URL)!
        components.path += methodPath
        return components.url!
    }
}
