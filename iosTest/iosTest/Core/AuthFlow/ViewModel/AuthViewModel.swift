//
//  AuthViewModel.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var login: String = ""
    @Published var password: String = ""
    
    @Published var isSuccessToastBarVisible = false
    private let toastShownKey = "hasShownSuccessToast"
    
    func logIn(completion: @escaping (Result<Void, Error>) -> Void) {
        if login == "Qwerty123" && password == "Qwerty123" {
            completion(.success(()))
        } else {
            completion(.failure(AuthError.invalidCredentials))
        }
    }
    
    func showSuccessToastIfNeeded() {
        let hasShown = UserDefaults.standard.bool(forKey: toastShownKey)
        guard !hasShown else { return }
        
        isSuccessToastBarVisible = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isSuccessToastBarVisible = false
            UserDefaults.standard.set(true, forKey: self.toastShownKey)
        }
    }
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Неверный логин или пароль."
        }
    }
}
