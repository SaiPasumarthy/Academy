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
                        .focused($focusedField, equals: .password)
                        .styledTextField()

                    Text("Password")
                        .secondaryHeadline()

                    SecureField("Enter password", text: $viewModel.password)
                        .focused($focusedField, equals: .username)
                        .styledTextField()
                }
                .padding(.horizontal)

                VStack(spacing: 14) {
                    Button(action: {
                        viewModel.signIn()
                        withAnimation(.easeInOut) {
                            showMainView = true
                        }
                    }) {
                        Text("Sign In")
                            .primaryButton()
                    }

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
