//
//  ProfileTextFiles.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 22/03/24.
//
import SwiftUI
struct ProfileTextFiles: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
        .padding(.horizontal)
    }
}
