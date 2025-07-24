//
//  NavigationBottomBar.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

struct NavigationBottomBar: View {
    @State private var selectedTab = 0
    
    var body: some View {
        CustomTabView(selectedTab: $selectedTab) {
            Group {
                if selectedTab == 0 {
                    MenuView()
                } else if selectedTab == 1 {
                    Text("Контакты")
                        .foregroundStyle(Color.theme.accentColor)
                } else if selectedTab == 2 {
                    Text("Профиль")
                        .foregroundStyle(Color.theme.accentColor)
                } else {
                    Text("Корзина")
                        .foregroundStyle(Color.theme.accentColor)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.theme.background)
    }
}

#Preview {
    NavigationBottomBar()
}
