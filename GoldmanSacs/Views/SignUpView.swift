//
//  SignUpView.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 30/04/26.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SignUpViewModel()
    @FocusState private var focusedField: FocusedField?

    
    var body: some View {
        VStack(spacing: 20) {
            Text("Please, SignUp")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 12) {
                Text("User Name")
                    .secondaryHeadline()
                

                TextField("Enter First Name", text: $viewModel.firstName)
                    .focused($focusedField, equals: .firstName)
                    .styledTextField()
                if let error = viewModel.firstNameError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                TextField("Enter Second Name(Optional)", text: Binding(
                    get: { viewModel.lastName ?? "" },
                    set: { viewModel.lastName = $0.isEmpty ? nil : $0 }
                ))
                    .focused($focusedField, equals: .lastName)
                    .styledTextField()
                
                Text("Email")
                    .secondaryHeadline()
                
                TextField("Enter Email", text: $viewModel.email)
                    .focused($focusedField, equals: .email)
                    .styledTextField()
                if let error = viewModel.emailError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Text("Password")
                    .secondaryHeadline()

                SecureField("Enter password", text: $viewModel.password)
                    .focused($focusedField, equals: .password)
                    .styledTextField()
                if let error = viewModel.passwordError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                SecureField("Confirm password", text: $viewModel.confirmPassword)
                    .focused($focusedField, equals: .confirmPassword)
                    .styledTextField()
                if let error = viewModel.confirmPasswordError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding(.horizontal)
            HStack {
                Button(action: {
                    Task {
                        if await viewModel.handleSignUp() {
                            LoginView()
                        } else {
                            viewModel.clearFailingFields()
                        } 
                         
                        focusedField = nil
                    }
                }) {
                    Text("Sign Up")
                        .primaryButton(backgroundColor: Color.gray.opacity(0.2), foregroundColor: .blue)
                }
                .padding(.trailing,10)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .primaryButton(backgroundColor: Color.gray.opacity(0.2), foregroundColor: .blue)
                }
                .padding(.leading,10)
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
        .padding(15)
        .alert(viewModel.userExistsAlertMessage, isPresented: $viewModel.showUserExistsAlert) {
            Button("OK", role: .cancel) { viewModel.clearFields() }
        }
        .alert(viewModel.successMessage, isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { 
                viewModel.clearFields()
                dismiss() 
                }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorAlert) {
            Button("OK") { 
                viewModel.clearFields()
            }
        }
        Spacer()
    }
}

enum FocusedField {
    case firstName, lastName, email, password, confirmPassword
}

#Preview {
    SignUpView()
}
