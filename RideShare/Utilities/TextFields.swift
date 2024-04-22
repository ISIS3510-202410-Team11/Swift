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


struct CustomPlateTextField: View {
    @Binding var text: String
    let title: String
    let maxLength: Int = 6

    var body: some View {
        TextField(title, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textContentType(.none)
            .keyboardType(keyboardTypeForText())
            .onChange(of: text) { newValue in
                // Ensure we don't exceed the maximum length and format text
                text = formatAndValidate(newValue)
            }
    }

    private func keyboardTypeForText() -> UIKeyboardType {
        return text.count < 3 ? .asciiCapable : .numberPad
    }

    private func formatAndValidate(_ input: String) -> String {
        var filtered = input.uppercased()
        
        // Ensure the letters and numbers are separated correctly
        if filtered.count > 3 {
            let lettersIndex = filtered.index(filtered.startIndex, offsetBy: 3)
            let letters = filtered[..<lettersIndex].filter { "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains($0) }
            let numbers = filtered[lettersIndex...].filter { "0123456789".contains($0) }
            filtered = String(letters + numbers)
        } else {
            filtered = String(filtered.filter { "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains($0) })
        }

        // Limit the length
        return String(filtered.prefix(maxLength))
    }
}
