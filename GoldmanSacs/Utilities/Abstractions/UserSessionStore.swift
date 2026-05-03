//
//  UserSessionStore.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 02/05/26.
//

import Foundation

protocol UserSessionStore {
    func saveUser(_ user: UserSession)
    func getUser() -> UserSession?
    func clearUser()
}
