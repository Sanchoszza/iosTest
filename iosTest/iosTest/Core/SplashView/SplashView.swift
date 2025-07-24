//
//  SplashView.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 1.0
    @State private var showWelcomeText: Bool = false
    
    var body: some View {
        VStack {
            if showWelcomeText {
                Image("logo")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 103)
                    .scaleEffect(scale)
                    .animation(.easeInOut(duration: 0.5), value: scale)
                    .foregroundStyle(Color.theme.colorWhite)
                    .padding()
            }
           
        }
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.theme.accentColor
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                scale = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showWelcomeText = true
                }
            }
        }
        .onDisappear {
            withAnimation(.easeInOut(duration: 0.3)) {
                scale = 0.95
            }
        }
    }
}

#Preview {
    SplashView()
}
