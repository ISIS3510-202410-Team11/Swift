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
    var backgroundColor: Color = .white

    var body: some View {
            Group {
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
            .background(backgroundColor) // Apply the background color here
            .cornerRadius(5) // Optional: Adds a corner radius if you want rounded corners
        }
    }
