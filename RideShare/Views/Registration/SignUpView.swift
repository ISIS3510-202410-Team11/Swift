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

    var body: some View {
        NavigationView {
            VStack(spacing: 35) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // Username field with immediate validation feedback
                CustomTextField(title: "Username", text: $viewModel.name)
                    .textFieldStyle(.plain)
                    .onChange(of: viewModel.name) { _ in
                        viewModel.validateName()  // Ensure this matches the method name in ViewModel
                    }
                    .overlay(
                        Group {
                            if let error = viewModel.nameError, !error.isEmpty {
                                Text(error)
                                    .foregroundColor(.red)
                                    .offset(y: 30)
                            }
                        }
                    )
                    
                // Email field with immediate validation feedback
                CustomTextField(title: "Email", text: $viewModel.email, isSecure: false)
                    .textFieldStyle(.plain)
                    .onChange(of: viewModel.email) { _ in
                        viewModel.validateEmail()  // Ensure this matches the method name in ViewModel
                    }
                    .overlay(
                        Group {
                            if let error = viewModel.emailError, !error.isEmpty {
                                Text(error)
                                    .foregroundColor(.red)
                                    .offset(y: 30)
                            }
                        }
                    )

                // Password field with immediate validation feedback
                CustomTextField(title: "Password", text: $viewModel.password, isSecure: true)
                    .textFieldStyle(.plain)
                    .onChange(of: viewModel.password) { _ in
                        viewModel.validatePassword()  // Ensure this matches the method name in ViewModel
                    }
                    .overlay(
                        Group {
                            if let error = viewModel.passwordError, !error.isEmpty {
                                Text(error)
                                    .foregroundColor(.red)
                                    .offset(y: 30)
                            }
                        }
                    )
                
                Toggle(isOn: $viewModel.isDriver) {
                    Text("I am a driver (Optional)")
                }.tint(.green)

                Toggle(isOn: $viewModel.wantsNewsletter) {
                    Text("I would like to receive your newsletter and other promotional information.")
                }.tint(.green)
                
                GreenButton(tittle: "Register") {
                    ClickCounter.shared.incrementCount()
                    viewModel.registerUser()
                }
                .disabled(!viewModel.isFormValid)
                
                NavigationLink(destination: NewCarView(onVehicleAdded: {}),
                               isActive: $viewModel.registrationSuccessful) { EmptyView() }
                
            }
            .padding()
            .background(Color.white)
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
