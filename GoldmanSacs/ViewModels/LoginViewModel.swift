//
//  LoginViewModel.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 26/04/26.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage = ""
    @Published var invalidCred: Bool = false
    @Published var isDisabled: Bool = true
    @Published var showErrorAlert = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private var authProvider: AuthenticationProvider
    private var sessionStore: UserSessionStore
    
    var welcomeMessage: String {
        let name = sessionStore.getUser().map { $0.firstName } ?? ""
        return name.isEmpty ? "Welcome Back" : "Welcome \(name.capitalized)"
    }
    
    init(authProvider: AuthenticationProvider = AuthenticationManager(),
         sessionStore: UserSessionStore = UserDefaultsSessionStorageManager()) {
        self.authProvider = authProvider
        self.sessionStore = sessionStore
        
        // Button state
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return !(CredentialValidator.isValidEmail(email) && CredentialValidator.isValidPassword(password))
            }
            .assign(to: \.isDisabled, on: self)
            .store(in: &cancellables)
    }
    
    func handleSignIn() async -> Bool {
        do {
            let authData = try await authProvider.signIn(email: email, password: password)
            sessionStore.saveUser(authData.user)
            return true
        } catch AuthenticationError.invalidCredential {
            errorMessage = "Incorrect Email or Password. if you are a new user click 'OK' to sign up"
            showErrorAlert = true
            invalidCred = true
            return false
        } catch AuthenticationError.networkError {
            errorMessage = "Network Error. Please try again"
            showErrorAlert = true
            return false
        } catch AuthenticationError.userNotFound {
            errorMessage = "User not found. Please try again"
            showErrorAlert = true
            return false
        } catch {
            errorMessage = "Unknown Error. Please try again."
            showErrorAlert = true
            return false
        }
    }
    
    func getCurrentUser() -> String {
        if let user = sessionStore.getUser() {
             return "\(user.firstName) \(user.lastName ?? "")"
        }
        return ""
    }
    
    func clearFields() {
        email = ""
        password = ""
    }
}
