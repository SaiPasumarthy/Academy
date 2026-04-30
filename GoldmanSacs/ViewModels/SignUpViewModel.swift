//
//  SignUpViewModel.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 30/04/26.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var firstNameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    
    @Published var showUserExistsAlert = false
    @Published var userExistsAlertMessage = ""
    
    @Published var showSuccessAlert = false
    @Published var successMessage = ""
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    @Published var isLoading = false

    private var authProvider: AuthenticationProvider

    init(authProvider: AuthenticationProvider = AuthencationManager.shared) {
        self.authProvider = authProvider
    }

    func handleSignUp() async -> Bool {
        if validateFields() {
            do {
                // Check if email is already registered
                if try await authProvider.isEmailRegistered(email) {
                    userExistsAlertMessage = "User already exists with this email. Try a different email."
                    showUserExistsAlert = true
                    return false
                }
                
                // Create user in Firebase Auth
                let authResult = try await createUserInAuth()
                
                // Save user metadata to Firestore through the auth provider
                let metadata = UserMetadata(
                    uid: authResult.uid,
                    email: email,
                    firstName: firstName,
                    lastName: lastName
                )
                try await authProvider.saveUserMetadata(metadata)
                
                // show success
                successMessage = "User registered successfully"
                showSuccessAlert = true
                return true
            } catch {
                errorMessage = error.localizedDescription + " Please try again later."
                showErrorAlert = true
                return false
            }
        } 
        return false
    }
    
    private func createUserInAuth() async throws -> AuthDataResultModel {
        return try await authProvider.createUser(email: email, password: password)
    }
    
    func validateFields() -> Bool {
        var isValid = true
        
        // Clear previous errors
        firstNameError = nil
        emailError = nil
        passwordError = nil
        confirmPasswordError = nil
        
        // Validate first name
        if firstName.count < 3  {
            firstNameError = "First name must be at least 3 characters"
            isValid = false
        } else {
            if firstName.filter({ $0.isLetter }).count < 2 {
                firstNameError = "First name must contain at least 2 alphabets"
                isValid = false
            }
        }
        
        // Validate email
        if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
            isValid = false
        }
        
        // Validate password strength
        if !isValidPassword(password) {
            passwordError = "Password must contain at least one lowercase, uppercase, number, and special character"
            isValid = false
        }
        
        // Validate passwords match
        if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
            isValid = false
        }
        
        return isValid
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    
    func clearFields() {
        firstName = ""
        lastName = nil
        email = ""
        password = ""
        confirmPassword = ""
    }
    
    func clearFailingFields() {
        if firstNameError != nil {
            firstName = ""
        }
        if emailError != nil {
            email = ""
        }
        if passwordError != nil || confirmPasswordError != nil {
            password = ""
            confirmPassword = ""

        }
    }
}
