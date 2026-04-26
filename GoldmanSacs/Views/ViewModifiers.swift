//
//  ViewModifiers.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 25/04/26.
//

import SwiftUI

struct SecondaryHeadlineModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.secondary)
    }
}

struct StyledTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .frame(height: 60)
            .font(.system(size: 20))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
            )
    }
}

struct PrimaryButtonModifier: ViewModifier {
    let backgroundColor: Color
    let foregroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .font(.system(size: 20))
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(10)
    }
}

extension View {
    func secondaryHeadline() -> some View {
        self.modifier(SecondaryHeadlineModifier())
    }
    
    func styledTextField() -> some View {
        self.modifier(StyledTextFieldModifier())
    }
    
    func primaryButton(backgroundColor: Color = .blue, foregroundColor: Color = .white) -> some View {
        self.modifier(PrimaryButtonModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}