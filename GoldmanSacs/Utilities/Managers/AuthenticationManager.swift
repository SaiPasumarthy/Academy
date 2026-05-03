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
    case invalidCredential
    case userNotFound
    case networkError
    case unknown
}

class AuthenticationManager: AuthenticationProvider {

    func signUp(data: UserData) async throws -> AuthDataResultModel {
        //create user
        let authDataResult = try await createUser(data: data)
        //save in database
        try await saveUserMetadata(data, id: authDataResult.id)
        return authDataResult
    }

    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        //Sign in
        let id = try await signingIn(email, password)
        //fetch user data from data base
        let userData = try await getUserMetadata(id: id)
        return AuthDataResultModel(id: userData.id, user: userData.user)
    }
    
    private func signingIn(_ email: String, _ password: String) async throws -> String {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return authDataResult.user.uid
        } catch {
            guard let err = error as NSError? else {
                throw AuthenticationError.unknown
            }
            switch AuthErrorCode(rawValue: err.code) {
            case .invalidCredential:
                throw AuthenticationError.invalidCredential
            case .networkError:
                print("Network error")
                throw AuthenticationError.networkError
            default:
                print("Unhandled error:", err.localizedDescription)
                throw AuthenticationError.unknown
            }
        }
    }

    private func createUser(data: UserData) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: data.email, password: data.password)
            return AuthDataResultModel(id: authDataResult.user.uid, user: data.user)
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
            "firstName": data.user.firstName,
            "lastName": data.user.lastName ?? ""
        ]
        do {
            try await usersCollection.document(id).setData(metadata)
        } catch {
            throw AuthenticationError.metadataNotSaved
        }
    }
    
    private func getUserMetadata(id: String) async throws -> AuthDataResultModel {
        let usersCollection = Firestore.firestore().collection("users")
        
        let document = try await usersCollection.document(id).getDocument()
        guard document.exists else {
            throw AuthenticationError.userNotFound
        }
        guard let firstName = document.get("firstName") as? String else {
            throw AuthenticationError.metadataNotSaved
        }
        let lastName = document.get("lastName") as? String
        return AuthDataResultModel(
            id: id,
            user: UserSession(firstName: firstName, lastName: lastName)
        )
    }

    func signOut() throws {
       //TODO: implement sign out logic
    }
}
