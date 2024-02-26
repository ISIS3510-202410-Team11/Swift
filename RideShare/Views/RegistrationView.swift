//
//  RegistrationView.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import Foundation
import SwiftUI
struct RegistrationView: View {
    @Binding var isAuthenticated: Bool
    @StateObject private var viewModel = RegistrationViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Centered Image
                Image("RideShare") // Replace "yourImageName" with your actual image asset name
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.6) // Example to make the image take up 60% of the screen width
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the image
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        GreenButton(title: "Sign Up") {
                            viewModel.login { success in
                                if success {
                                    print("Login successful!")
                                    self.isAuthenticated = true
                                } else {
                                    print("Login failed!")
                                }
                            }
                        }
                        .disabled(viewModel.username.isEmpty || viewModel.password.isEmpty)
                        
                        GreenButton(title: "Log In") {
                            viewModel.login { success in
                                if success {
                                    print("Login successful!")
                                    self.isAuthenticated = true
                                } else {
                                    print("Login failed!")
                                }
                            }
                        }
                        .disabled(viewModel.username.isEmpty || viewModel.password.isEmpty)
                    }
                    .padding([.horizontal, .bottom]) // Add horizontal and bottom padding
                    
                }
                .frame(width: geometry.size.width, height: geometry.size.height) // Use GeometryReader's height and width
            }
            .edgesIgnoringSafeArea(.all) // Adjust based on your design requirements
        }
    }
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            // Create a temporary binding for isAuthenticated
            // For preview purposes, we initialize it with false
            RegistrationView(isAuthenticated: .constant(false))
        }
    }
    
    
}
