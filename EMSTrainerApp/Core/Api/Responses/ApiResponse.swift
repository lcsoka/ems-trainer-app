//
//  ApiResponse.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    let data: T
}
