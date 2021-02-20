//
//  UserService.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 02. 20..
//

import Foundation

class UserService {
    
    static let shared = UserService()
    
    private var user: User?
    
    private func loadSavedUser() {
        if let savedUser = UserDefaults.standard.object(forKey: "User") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUser) {
                self.user = loadedUser
            }
        }
    }
    
    public func setUser(_ user: User?) {
        self.user = user
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "User")
        }
    }
    
    public func getUser() -> User? {
        return user
    }
    
}
