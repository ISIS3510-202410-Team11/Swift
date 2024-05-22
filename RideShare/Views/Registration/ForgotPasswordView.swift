//
//  ForgotPasswordView.swift
//  RideShare
//
//  Created by Pablo Junco on 22/03/24.
//

import Foundation
import SwiftUI
struct ForgotPasswordView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @State private var navigateTologinView = false 

    var body: some View {
        NavigationView{
            VStack {
                
                Text("RideShare password recovery")
                    .font(.title2)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                GreenButton(tittle:"Recover Password") {
                    AnalyticsManager.shared.logEvent(name: "User Recovers Passwords", params: ["ForgotPassword View":"RecoverPassword Button"])
                    //remove in the future
                    ClickCounter.shared.incrementCount()
                    loginViewModel.recoverPassword(for: email) { success, message in
                        alertMessage = success ? "Check your email to reset your password." : (message ?? "An error occurred.")
                        showAlert = true
                        navigateTologinView = true
                        
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Password Recovery"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: LoginView(), isActive: $navigateTologinView) { EmptyView() }
            }
            .padding()
            
        }
    }
    
}

struct ForgotPasswordView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        ForgotPasswordView()
    }
}
