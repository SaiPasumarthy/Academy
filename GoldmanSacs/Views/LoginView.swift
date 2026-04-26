//
//  LoginView.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 25/04/26.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showMainView = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Username")
                        .secondaryHeadline()
                    

                    TextField("Enter username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .styledTextField()

                    Text("Password")
                        .secondaryHeadline()

                    SecureField("Enter password", text: $password)
                        .styledTextField()
                }
                .padding(.horizontal)

                VStack(spacing: 14) {
                    Button(action: {
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
    }
}

#Preview {
    LoginView()
}
