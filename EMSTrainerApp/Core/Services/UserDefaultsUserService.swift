//
//  UserDefaultsUserService.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation

final class UserDefaultsUserService: UserService {
    var currentUser: User? {
        get {
            let coder = JSONDecoder()
            guard let value = UserDefaults.standard.data(forKey: "User"), let source = try? coder.decode(User.self, from: value) else {
                return nil
            }
            return source
        }
        
        set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: "User")
                return
            }
            
            let coder = JSONEncoder()
            guard let data = try? coder.encode(value) else {
                return 
            }
            
            UserDefaults.standard.set(data, forKey: "User")
        }
    }
}
