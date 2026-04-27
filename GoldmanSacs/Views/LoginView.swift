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
    
    @FocusState private var focusedField: Field?

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Username")
                        .secondaryHeadline()
                    

                    TextField("Enter username", text: $viewModel.userName)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .username)
                        .styledTextField()

                    Text("Password")
                        .secondaryHeadline()

                    SecureField("Enter password", text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                        .styledTextField()
                }
                .padding(.horizontal)

                VStack(spacing: 14) {
                    Button(action: {
                        // TODO: handle sign in action
                    }) {
                        Text("Sign In")
                            .primaryButton(backgroundColor: viewModel.isValid ? Color.blue : Color.gray.opacity(0.5), foregroundColor: .white)
                    }
                    .disabled(!viewModel.isValid)

                    Button(action: {
                        // TODO: handle sign up action
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
            
            
            if showMainView {
                GoldmanSacksView(showMainView: $showMainView)
                    .transition(.move(edge: .trailing))
                    .zIndex(1)
            }
            
        }
        .onChange(of: showMainView) { _, newValue in
            if !newValue {
                viewModel.clearUserCredentials()
                focusedField = nil
            }
        }
    }
    
}

enum Field {
    case username, password
}

#Preview {
    LoginView()
}
