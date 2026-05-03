//
//  UserDefaultsSessionStorageManager.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 02/05/26.
//

import Foundation

final class UserDefaultsSessionStorageManager: UserSessionStore {
    
    private let defaults: UserDefaults
    private let userKey = "logged_in_user"
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func saveUser(_ user: UserSession) {
        if let data = try? JSONEncoder().encode(user) {
            defaults.set(data, forKey: userKey)
        }
    }
    
    func getUser() -> UserSession? {
        guard let data = defaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(UserSession.self, from: data) else {
            return nil
        }
        return user
    }
    
    func clearUser() {
        defaults.removeObject(forKey: userKey)
    }
}
