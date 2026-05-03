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
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    @Published var showSuccessAlert = false
    @Published var successMessage = ""
    
    @Published var isLoading = false

    private var authProvider: AuthenticationProvider

    init(authProvider: AuthenticationProvider = AuthenticationManager()) {
        self.authProvider = authProvider
    }

    func handleSignUp() async -> Bool {
        if validateFields() {
            do {
                // Create user in Firebase Auth
                _ = try await signUp()

                // show success
                successMessage = "User registered successfully"
                showSuccessAlert = true
                return true
            } catch AuthenticationError.emailAlreadyRegistered {
                errorMessage = "User already exists with this email. Try a different email."
                showErrorAlert = true
                return false
            } catch AuthenticationError.metadataNotSaved {
                errorMessage = "Failed to save user metadata. Please try again later."
                showErrorAlert = true
                return false
            }catch AuthenticationError.unknown {
                errorMessage = "Unknown error. Please try again later."
                showErrorAlert = true
                return false
            } catch {
                errorMessage = error.localizedDescription + " Please try again later."
                showErrorAlert = true
                return false
            }
        } 
        return false
    }
    
    private func signUp() async throws -> AuthDataResultModel {
        return try await authProvider
            .signUp(
            data: UserData(
                user: UserSession(firstName: firstName.trimmingCharacters(in: .whitespaces), lastName: lastName?.trimmingCharacters(in: .whitespaces)),
                email: email.trimmingCharacters(in: .whitespaces),
                password: password.trimmingCharacters(in: .whitespaces)
            )
        )
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
        if !CredentialValidator.isValidEmail(email) {
            emailError = "Please enter a valid email address"
            isValid = false
        }
        
        // Validate password strength
        if !CredentialValidator.isValidPassword(password) {
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
