//
//  UserDefaults.swift
//  yarin_cards
//
//  Created by Udi Levy on 17/07/2024.
//

import Foundation


class UserDefaultsUtils {
    private static let userNameKey = "userName"
    
    static func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: userNameKey)
    }
    
    static func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: userNameKey)
    }
    
    static func clearUserName() {
        UserDefaults.standard.removeObject(forKey: userNameKey)
    }
}
