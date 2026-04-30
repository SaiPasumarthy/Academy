//
//  SignUpViewModel.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 30/04/26.
//

import Foundation
import Combine
import FirebaseFirestore

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

    private var authProvider: AuthenticationProvider

    init(authProvider: AuthenticationProvider = AuthencationManager.shared) {
        self.authProvider = authProvider
    }

    func handleSignUp() async -> Bool {
        if validateFields() {
            do {
                // Check if user already exists
                if let existenceMessage = try await checkUserExists() {
                    userExistsAlertMessage = existenceMessage
                    showUserExistsAlert = true
                    return false
                }
                
                // Create user in Firebase Auth
                let authResult = try await createUserInAuth()
                
                // Save user metadata to Firestore
                try await saveUserMetadata(uid: authResult.uid)
                
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
    
    private func checkUserExists() async throws -> String? {
        let usersCollection = Firestore.firestore().collection("users")
        let normalizedEmail = email.lowercased()
        let normalizedName = firstName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        //verifying email and firstname are matching with the existing user, if not then showing email already exists message, if matching then showing user already exists message
        let emailQuery = try await usersCollection.whereField("email", isEqualTo: normalizedEmail).getDocuments()
        if let existingEmailDoc = emailQuery.documents.first,
           let existingUsername = existingEmailDoc.data()["username"] as? String {
            if existingUsername.lowercased() != normalizedName {
                return "User already exists with this email. Try a different email."
            }
            return "User already exists. Try a different name and email."
        }
        //if user first name is matching with the existing user, then showing user already exists message, if not then allowing to create new user
        let nameQuery = try await usersCollection.whereField("username", isEqualTo: normalizedName).getDocuments()
        if !nameQuery.documents.isEmpty {
            return "User already exists. Try a different name and email."
        }
        
        return nil
    }
    
    private func saveUserMetadata(uid: String) async throws {
        let usersCollection = Firestore.firestore().collection("users")
        let data: [String: Any] = [
            "username": firstName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            "email": email.lowercased(),
            "firstName": firstName,
            "lastName": lastName ?? "",
            "uid": uid
        ]
        try await usersCollection.document(uid).setData(data)
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
        if passwordError != nil {
            password = ""
        }
        if confirmPasswordError != nil {
            confirmPassword = ""
        }
    }
}
