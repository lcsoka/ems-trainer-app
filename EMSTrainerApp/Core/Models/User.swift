//
//  User.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 16..
//

import Foundation

struct User: Codable, Equatable {
    var id: Int
    var email: String
    var name: String
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.email == rhs.email && lhs.id == rhs.id
    }
}

