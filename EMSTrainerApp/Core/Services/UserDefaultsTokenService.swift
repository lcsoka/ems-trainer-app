//
//  UserDefaultsTokenService.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation

class UserDefaultsTokenService: TokenService {
    var token: String? {
        get {
            guard let value = UserDefaults.standard.string(forKey: "Token") else {
                return nil
            }
            return value
        }
        set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: "Token")
                return
            }
            
            UserDefaults.standard.set(value, forKey: "Token")
        }
    }
}
