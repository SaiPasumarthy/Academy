//
//  AuthenticationManager.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 26/04/26.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}
class AuthencationManager: AuthenticationProvider {
    static let shared = AuthencationManager()
    
    private init() { }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }

    func signOut() throws {
       //TODO: implement sign out logic
    }
}
