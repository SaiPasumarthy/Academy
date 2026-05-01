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
    
    func signIn() {
        guard isValid else {
            print("Email or password does not meet requirements")
            return
        }

       // TODO: Verify credentials with backend service
    }
    
    func clearUserCredentials() {
        email = ""
        password = ""
    }
    
    var isValid: Bool {
        let emailValid = email.count >= 3
        let passwordValid = password.count >= 8 &&
            password.contains(where: { $0.isUppercase }) &&
            password.contains(where: { $0.isLowercase }) &&
            password.contains(where: { $0.isNumber }) &&
            password.contains(where: { !$0.isLetter && !$0.isNumber && !$0.isWhitespace })
        return emailValid && passwordValid
    }
}
