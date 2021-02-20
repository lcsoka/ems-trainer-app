//
//  UserResponse.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

struct UserResponse: Codable {
    var user: User
    var accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}
