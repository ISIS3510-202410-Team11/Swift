//
//  SignUpView.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI
struct SignUpView: View {
    @EnvironmentObject var userSession: UserSession
        @StateObject var viewModel = SignUpViewModel()
    @State private var user = User(uid:"", name: "", email: "", driver: false, newsletter: false)
    @State private var isSignUpComplete = false
    @State private var isDriver = false
    @State private var wantsNewsletter = false
    @State private var navigateToVehicleForm = false
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .tint(.black)
                
                CustomTextField(title: "Username", text: $viewModel.name).textFieldStyle(.plain)
                
                CustomTextField(title: "Email", text: $viewModel.email, keyboardType: .emailAddress).textFieldStyle(.plain)
                
                CustomTextField(title: "Password", text: $viewModel.password, isSecure: true).textFieldStyle(.plain)
                
                Toggle(isOn: $viewModel.isDriver) {
                    Text("I am a driver (Optional)")
                }
                .tint(.green)
                            
                Toggle(isOn: $viewModel.wantsNewsletter) {
                    Text("I would like to receive your newsletter and other promotional information.")
                }
                .tint(.green)

                
                GreenButton(title: "Register") {
                    navigateToVehicleForm = true
                    viewModel.registerUser()
                    
                    
                            }
                            .disabled(!viewModel.isFormValid)

                
                Spacer()
                
                NavigationLink(destination: NewCarView(), isActive: $navigateToVehicleForm) { EmptyView() }
            }
            .padding()
            .background(Color.white)
            .alert(isPresented: $viewModel.showAlert) { // Use ViewModel's showAlert for binding
                        Alert(title: Text("Registration"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                            // Pass the shared userSession to viewModel
                            viewModel.userSession = userSession
                        }
            
            
            
        }
        
        
    }
    
    //This should be at loginViewModel at some time to check that the user doesn't exist already in the DB
    var isFormValid: Bool {
            !user.name.isEmpty && !user.email.isEmpty
        }
}

struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        SignUpView()
    }
}
