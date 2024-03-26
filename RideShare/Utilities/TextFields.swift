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
    @Binding var text: String
    var isSecure: Bool = false // Determines if this is a secure field or not
    var keyboardType: UIKeyboardType = .default
    var backgroundColor: Color = .white
    var isPicker: Bool = false
    var pickerOptions: [String] = []

    var body: some View {
        Group {
            if isPicker {
                Picker(title, selection: $text) {
                    ForEach(pickerOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(.green)
            } else if isSecure {
                SecureField(title, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
            } else {
                TextField(title, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
            }
        }
        .background(backgroundColor)
        .cornerRadius(5)
    }
}
