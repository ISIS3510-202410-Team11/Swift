//
//  Buttons.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import Foundation
import SwiftUI
struct GreenButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(title, action: action)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
    }
}

struct RedButton: View {
    var title: String
    var action: () -> Void
    var body: some View {
        Button(title, action: action)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(10)
    }
}
