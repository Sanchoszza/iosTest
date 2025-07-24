//
//  UIApplication.swift
//  iosTest
//
//  Created by Александра Згонникова on 24.07.2025.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
