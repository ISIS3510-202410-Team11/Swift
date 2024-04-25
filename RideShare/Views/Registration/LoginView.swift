//
//  LoginView.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    @State private var authenticationFailed = false
    @State private var authenticationErrorMessage: String = ""
    @State private var navigateToMapView = false // To control navigation
    @State private var navigateToForgotPassword = false // To control navigation
    
 
    //    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                
                CustomTextField(title: "Email", text: $loginViewModel.username, keyboardType: .emailAddress)
                    .cornerRadius(5)
                
                CustomTextField(title: "Password", text: $loginViewModel.password, isSecure: true)
                    .cornerRadius(5)
                
                
                GreenButton(tittle: "Login", action: {
                    loginViewModel.login { success, errorMessage in
                        if success {
                            print("Login successful")
                            navigateToMapView = true
                        } else {
                            loginViewModel.authenticationFailed = true
                            loginViewModel.authenticationErrorMessage = errorMessage ?? "An error occurred"
                        }
                    }
                })
                .disabled(loginViewModel.username.isEmpty || loginViewModel.password.isEmpty)
                
                GreenButton(tittle: "Login with Face ID", action: {
                    loginViewModel.authenticateUserUsingFaceID { success, error in
                        if success {
                            self.navigateToMapView = true
                        }
                    }
                })
                .disabled(!LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil))
                .padding()
                
                
                Text("Forgot your password?")
                    .frame(maxWidth:.infinity)
                    .foregroundColor(.green)
                    .onTapGesture {
                        navigateToForgotPassword = true
                    }
                // NavigationLink that is always present but not visible until activated
                NavigationLink(destination: ForgotPasswordView(), isActive: $navigateToForgotPassword) {
                    EmptyView()
                }
                
                
            }
            .alert(isPresented: $loginViewModel.authenticationFailed) {
                Alert(title: Text("Authentication Failed"), message: Text(loginViewModel.authenticationErrorMessage), dismissButton: .default(Text("OK")))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align content to the top
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Ensure the whole screen background is white
        }
        .fullScreenCover(isPresented: $navigateToMapView) {
            Tabvar(startingTab: .home) // This presents the Tabvar component in full-screen mode
        }
    }
}

//struct Login_View_Preview: PreviewProvider {
//    static var previews: some View {
//        // Create a temporary binding for isAuthenticated
//        // For preview purposes, we initialize it with false
//        LoginView()
//    }
//}
