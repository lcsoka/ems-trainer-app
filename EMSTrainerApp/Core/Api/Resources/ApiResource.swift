//
//  ApiResource.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

protocol ApiResource {
    associatedtype ModelType: Codable
    var customUrl: String? { get set }
    var methodPath: String { get }
}
 
extension ApiResource {
    var url: URL {
        var components = URLComponents(string: customUrl != nil ? customUrl! : AppConfig.API_URL)!
        components.path += methodPath
        return components.url!
    }
}
