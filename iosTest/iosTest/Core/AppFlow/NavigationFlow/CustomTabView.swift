//
//  CustomTabView.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

struct CustomTabView<Content: View>: View {
    @Binding var selectedTab: Int
    let content: Content
    
    init(selectedTab: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                content
            }
            Spacer(minLength: 0)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .edgesIgnoringSafeArea(.horizontal)
            
            HStack {
                Button(action: { selectedTab = 0 }) {
                    VStack {
                        Image("menu")
                            .foregroundStyle(selectedTab == 0 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                        Text(NSLocalizedString("menu", comment: ""))
                            .font(.custom("SF UI Display", size: 13))
                            .fontWeight(.regular)
                            .foregroundStyle(selectedTab == 0 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                    }
                    
                }
                Spacer()
                Button(action: { selectedTab = 1 }) {
                    VStack {
                        Image("contacts")
                            .foregroundStyle(selectedTab == 1 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                        Text(NSLocalizedString("contacts", comment: ""))
                            .font(.custom("SF UI Display", size: 13))
                            .fontWeight(.regular)
                            .foregroundStyle(selectedTab == 1 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                    }
                   
                }
                Spacer()
                Button(action: { selectedTab = 2 }) {
                    VStack {
                        Image("loginIcon")
                            .foregroundStyle(selectedTab == 2 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                        Text(NSLocalizedString("profile", comment: ""))
                            .font(.custom("SF UI Display", size: 13))
                            .fontWeight(.regular)
                            .foregroundStyle(selectedTab == 2 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                    }
                }
                Spacer()
                Button(action: { selectedTab = 3 }) {
                    VStack {
                        Image("basket")
                            .foregroundStyle(selectedTab == 3 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                        Text(NSLocalizedString("basket", comment: ""))
                            .font(.custom("SF UI Display", size: 13))
                            .fontWeight(.regular)
                            .foregroundStyle(selectedTab == 3 ? Color.theme.accentColor : Color.theme.secondaryNavig)
                    }
                }
            }
            .padding(.horizontal, 30)
            .frame(height: 70) 
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
        }
    }
}
