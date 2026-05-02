//
//  CredentialValidator.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 02/05/26.
//

import Foundation

struct CredentialValidator {
    private static let emailPredicate = NSPredicate(format: "SELF MATCHES %@","[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    private static let passwordPredicate = NSPredicate(format: "SELF MATCHES %@",
    "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{6,}$")

    static func isValidEmail(_ email: String) -> Bool {
        emailPredicate.evaluate(with: email)
    }

    static func isValidPassword(_ password: String) -> Bool {
        passwordPredicate.evaluate(with: password)
    }
}
