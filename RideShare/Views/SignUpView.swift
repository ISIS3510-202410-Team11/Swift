//
//  SignUpView.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI
struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var user = User(name: "", email: "", password: "")
    @State private var isSignUpComplete = false
    @State private var isDriver = false
    @State private var wantsNewsletter = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .tint(.black)
            
            CustomTextField(title: "Username", text: $viewModel.name).textFieldStyle(.plain)
            
            CustomTextField(title: "Email", text: $viewModel.email, keyboardType: .emailAddress).textFieldStyle(.plain)
            
            CustomTextField(title: "Password", text: $viewModel.password, isSecure: true).textFieldStyle(.plain)
            
            Toggle(isOn: $isDriver) {
                Text("I am a driver (Optional)")
            }
            .tint(.black)
                        
            Toggle(isOn: $wantsNewsletter) {
                Text("I would like to receive your newsletter and other promotional information.")
            }
            .tint(.black)

            
            GreenButton(title: "Register") {
                            viewModel.registerUser() // Directly call without a closure
                        }
                        .disabled(!viewModel.isFormValid)

            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .alert(isPresented: $viewModel.showAlert) { // Use ViewModel's showAlert for binding
                    Alert(title: Text("Registration"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
        
    }
    
    //This should be at loginViewModel at some time to check that the user doesn't exist already in the DB
    var isFormValid: Bool {
            !user.name.isEmpty && !user.email.isEmpty && !user.password.isEmpty
        }
}

struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        SignUpView()
    }
}
