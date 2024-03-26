//
//  SignUpView.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI
struct SignUpView: View {
    @StateObject var viewModel = SignUpViewModel()
    @State private var navigateToVehicleForm = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                CustomTextField(title: "Username", text: $viewModel.name).textFieldStyle(.plain)
                CustomTextField(title: "Email", text: $viewModel.email, keyboardType: .emailAddress).textFieldStyle(.plain)
                CustomTextField(title: "Password", text: $viewModel.password, isSecure: true).textFieldStyle(.plain)
                
                Toggle(isOn: $viewModel.isDriver) {
                    Text("I am a driver (Optional)")
                }.tint(.green)
                
                Toggle(isOn: $viewModel.wantsNewsletter) {
                    Text("I would like to receive your newsletter and other promotional information.")
                }.tint(.green)
                
                GreenButton(title: "Register") {
                    viewModel.registerUser()
                }
                .disabled(!viewModel.isFormValid)

                NavigationLink(destination: NewCarView(), isActive: $viewModel.registrationSuccessful) { EmptyView() }
            }
            .padding()
            .background(Color.white)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Registration"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct SignUpView_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        SignUpView()
    }
}
