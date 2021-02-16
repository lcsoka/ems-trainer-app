//
//  ApiResponse.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String?
    let data: T
}
