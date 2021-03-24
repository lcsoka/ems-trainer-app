//
//  ApiErrorResponse.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 19..
//

import Foundation

struct ApiErrorResponse: Codable {
    var errors: [ApiError]
    struct ApiError: Codable {
        var errorCode: String
        var errorMessage: String
        
        enum CodingKeys: String, CodingKey {
            case errorCode = "error_code"
            case errorMessage = "error_message"
        }
    }
}
