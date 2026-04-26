//
//  LoginViewModel.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 26/04/26.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var password: String = ""
    
    func signIn() {
        let email = userName + "@test.com"
        guard !userName.isEmpty, !password.isEmpty else {
            print("No Email or Password provided")
            return
        }
        
        Task {
            do {
                let returnedUserData = try await AuthencationManager.shared.createUser(email: email, password: password)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func clearUserCredentials() {
        userName = ""
        password = ""
    }
}
