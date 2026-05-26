//
//  LoginView.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 25/04/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showMainView = false
    @State private var showSignUpView: Bool = false
    @State private var showPassword = false
    
    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text(viewModel.welcomeMessage)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Email")
                        .secondaryHeadline()
                    

                    TextField("Enter Email", text: $viewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .email)
                        .styledTextField()
                    if !CredentialValidator.isValidEmail(viewModel.email) {
                        Text(verbatim: "e.g. john@example.com")
                            .font(.caption)
                            .italic()
                            .foregroundColor(.gray)
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
                }
                .padding(.horizontal)

                VStack(spacing: 14) {
                    Button(action: {
                        Task {
                            viewModel.isLoading = true
                            if await viewModel.handleSignIn() {
                                showMainView = true
                            }
                            viewModel.isLoading = false
                        }
                        
                    }) {
                        Text("Sign In")
                            .primaryButton(backgroundColor: viewModel.isDisabled ? Color.gray.opacity(0.5):Color.blue, foregroundColor: .white)
                    }
                    .disabled(viewModel.isDisabled)

                    Button(action: {
                        showSignUpView = true
                    }) {
                        Text("Sign Up")
                            .primaryButton(backgroundColor: Color.gray.opacity(0.2), foregroundColor: .blue)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $showSignUpView) {
                SignUpView()
            }
            
            if showMainView {
                GoldmanSacksView(showMainView: $showMainView)
                    .transition(.move(edge: .trailing))
                    .zIndex(1)
            }
            
        }
        .loadingOverlay(viewModel.isLoading)
        .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorAlert) {
            Button("Cancel", role: .cancel) {
                viewModel.clearFields()
                focusedField = nil
            }
            if viewModel.invalidCred {
                Button("OK") {
                    showSignUpView = true
                    viewModel.clearFields()
                    viewModel.invalidCred = false
                    focusedField = nil
                }
            }
            
        }
        .onChange(of: showMainView) { _, newValue in
            if !newValue {
                viewModel.clearFields()
                focusedField = nil
            }
        }
    }
    
}

enum Field {
    case email, password
}

#Preview {
    LoginView()
}
