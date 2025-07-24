//
//  iosTestApp.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

@main
struct iosTestApp: App {
    
    init() {
        configureAppearance()
    }
    
    private func configureAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accentColor)
        UITableView.appearance().backgroundColor = UIColor.clear

        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.theme.accentColor)
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor : UIColor.white
        ]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
        UITextView.appearance().backgroundColor = .clear
        UITextView.appearance().tintColor = UIColor(Color.theme.accentColor)
        
        UIButton.appearance().isExclusiveTouch = true
        UIButton.appearance().isOpaque = true
    }
    
    @State private var showSplash = true
    @State private var authenticated = false
    
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .opacity(showSplash ? 1 : 0)
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                showSplash = false
                                authenticated = true
                            }
                        }
                    }
            } else {
                AuthView()
            }
        }
    }
}


class AppState: ObservableObject {
//    @Published var isLoggedIn: Bool = SPHelper.getActiveUser()
}
