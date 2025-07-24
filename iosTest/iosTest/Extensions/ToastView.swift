//
//  ToastView.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

struct ToastView: View {
    var message: String
    var color: Color
    var textColor: Color
    var image: String

    var body: some View {
        HStack(spacing: 15) {
            
            Text(message)
                .foregroundStyle(textColor)
                .font(.custom("Assistant", size: 16))
                .fontWeight(.regular)
            
            Image(image)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(textColor)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(color)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
        .padding(.horizontal)
        .padding(.top, 80)
    }
}

extension View {
    func showToast(
        message: String,
        color: Color,
        textColor: Color,
        image: String,
        isVisible: Binding<Bool>,
        duration: Double = 2.0
    ) -> some View {
        self
            .overlay(
                Group {
                    if isVisible.wrappedValue {
                        ToastView(
                            message: message,
                            color: color,
                            textColor: textColor,
                            image: image
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(999)
                    }
                },
                alignment: .top
            )
            .ignoresSafeArea(edges: .top)
            .onChange(of: isVisible.wrappedValue) { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isVisible.wrappedValue = false
                        }
                    }
                }
            }
    }
}

