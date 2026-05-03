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
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Please, SignUp")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("User Name")
                        .secondaryHeadline()
                    
                    
                    TextField("Enter First Name", text: $viewModel.firstName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .firstName)
                        .styledTextField()
                    if let error = viewModel.firstNameError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    TextField("Enter Last Name(Optional)", text: Binding(
                        get: { viewModel.lastName ?? "" },
                        set: { viewModel.lastName = $0.isEmpty ? nil : $0 }
                    ))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .focused($focusedField, equals: .lastName)
                    .styledTextField()
                    
                    Text("Email")
                        .secondaryHeadline()
                    
                    TextField("Enter Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .email)
                        .styledTextField()
                    if let error = viewModel.emailError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Text("Password")
                        .secondaryHeadline()
                    
                    HStack {
                        if showPassword {
                            TextField("Enter password", text: $viewModel.password)
                                .focused($focusedField, equals: .password)
                        } else {
                            SecureField("Enter password", text: $viewModel.password)
                                .focused($focusedField, equals: .password)
                        }
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .styledTextField()
                    if let error = viewModel.passwordError {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    HStack {
                        if showConfirmPassword {
                            TextField("Confirm password", text: $viewModel.confirmPassword)
                                .focused($focusedField, equals: .confirmPassword)
                        } else {
                            SecureField("Confirm password", text: $viewModel.confirmPassword)
                                .focused($focusedField, equals: .confirmPassword)
                        }
                        Button(action: { showConfirmPassword.toggle() }) {
                            Image(systemName: showConfirmPassword ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(.gray)
                        }
                    }
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
                            viewModel.isLoading = true
                            if await !viewModel.handleSignUp() {
                                viewModel.clearFailingFields()
                            }
                            viewModel.isLoading = false
                            focusedField = nil
                        }
                    }) {
                        Text("Sign Up")
                    }
                    .disabled(viewModel.isLoading)
                    .primaryButton(backgroundColor: Color.gray.opacity(0.2), foregroundColor: .blue)
                    .padding(.trailing,10)
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .primaryButton(backgroundColor: Color.gray.opacity(0.2), foregroundColor: .blue)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.leading,10)
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .padding(15)
            .alert(viewModel.successMessage, isPresented: $viewModel.showSuccessAlert) {
                Button("OK") {
                    viewModel.clearFields()
                    dismiss()
                }
            }
            .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorAlert) {
               Button("OK", role: .cancel) { viewModel.clearFields() }
            }
            Spacer()
            
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.6))
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

enum FocusedField {
    case firstName, lastName, email, password, confirmPassword
}

#Preview {
    SignUpView()
}
