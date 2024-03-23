//
//  SignUpView.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI
struct SignUpView: View {
    @State private var user = User(name: "", email: "", password: "")
    @State private var isSignUpComplete = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            CustomTextField(title: "Username", text: $user.name)
            
            CustomTextField(title: "Email", text: $user.email, keyboardType: .emailAddress)
            
            CustomTextField(title: "Password", text: $user.password, isSecure: true)
            
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Text("I am a driver (Optional)")
            }
            
            
            Toggle(isOn: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is On@*/.constant(true)/*@END_MENU_TOKEN@*/) {
                Text("I would like to receive your newsletter and other promotional information.")
            }

            
            GreenButton(title: "Sign Up", action: {
                // Perform the sign-up action here
                print("Performing sign-up...")
                isSignUpComplete = true
            }).disabled(!isFormValid)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $isSignUpComplete) {
            Alert(title: Text("Sign Up Complete"), message: Text("Welcome, \(user.name)!"), dismissButton: .default(Text("OK")))
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
