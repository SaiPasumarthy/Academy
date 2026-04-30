//
//  AuthenticationProvider.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 27/04/26.
//

import Foundation

struct UserMetadata {
    let uid: String
    let email: String
    let firstName: String
    let lastName: String?
}

protocol AuthenticationProvider {
    func createUser(email: String, password: String) async throws -> AuthDataResultModel
    func signIn(email: String, password: String) async throws -> AuthDataResultModel
    func isEmailRegistered(_ email: String) async throws -> Bool
    func saveUserMetadata(_ metadata: UserMetadata) async throws
    func signOut() throws
}
