//
//  RegisterData.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

struct RegisterData: Encodable{
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
    
    enum CodingKeys: String, CodingKey {
        case name, email, password
        case passwordConfirmation = "password_confirmation"
    }
}
