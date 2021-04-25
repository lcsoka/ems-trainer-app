//
//  UserDefaultsAchievementsService.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 25..
//

import Foundation

final class UserDefaultsAchievementsService: AchievementsService {
    var achievements: [Achievement]? {
        get {
            let coder = JSONDecoder()
            guard let value = UserDefaults.standard.data(forKey: "Achievements"), let source = try? coder.decode([Achievement].self, from: value) else {
                return nil
            }
            return source
        }
        
        set {
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: "Achievements")
                return
            }
            
            let coder = JSONEncoder()
            guard let data = try? coder.encode(value) else {
                return
            }
            UserDefaults.standard.set(data, forKey: "Achievements")
        }
    }
}
