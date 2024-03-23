//
//  TextFields.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI
struct CustomTextField: View {
    var title: String
    var text: Binding<String>
    var isSecure: Bool = false // Determines if this is a secure field or not
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        if isSecure {
            SecureField(title, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        } else {
            TextField(title, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(keyboardType)
                .autocapitalization(.none)
        }
    }
}
