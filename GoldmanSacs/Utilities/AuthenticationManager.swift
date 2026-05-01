//
//  AuthenticationManager.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 26/04/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthenticationError: Error {
    case emailAlreadyRegistered
    case metadataNotSaved
    case unknown
}

class AuthencationManager: AuthenticationProvider {

    func signUp(data: UserData) async throws -> AuthDataResultModel {
        //create user
        let authDataResult = try await createUser(data: data)
        //save in database
        try await saveUserMetadata(data, id: authDataResult.id)
        return authDataResult
    }

    func signIn(data: UserData) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: data.email, password: data.password)
        return AuthDataResultModel(id: authDataResult.user.uid,email: authDataResult.user.email ?? "", firstName: data.firstName, lastName: data.lastName ?? "")
    }

    private func createUser(data: UserData) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: data.email, password: data.password)
            return AuthDataResultModel(id: authDataResult.user.uid,email: authDataResult.user.email ?? "", firstName: data.firstName, lastName: data.lastName ?? "")
        } catch {
            if let err = error as NSError?,
               AuthErrorCode(rawValue: err.code) == .emailAlreadyInUse {
                throw AuthenticationError.emailAlreadyRegistered
            } else {
                throw AuthenticationError.unknown
            }
        }
    }
    
    private func saveUserMetadata(_ data: UserData, id: String) async throws {
        let usersCollection = Firestore.firestore().collection("users")
        let metadata: [String: Any] = [
            "firstName": data.firstName,
            "lastName": data.lastName ?? "",
            "email": data.email,
            "password": data.password
        ]
        do {
            try await usersCollection.document(id).setData(metadata)
        } catch {
            throw AuthenticationError.metadataNotSaved
        }
    }

    func signOut() throws {
       //TODO: implement sign out logic
    }
}
