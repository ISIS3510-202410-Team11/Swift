//
//  LoginView.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI
import LocalAuthentication

// Custom Keyboard Responder
class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    var keyboardShowObserver: NSObjectProtocol?
    var keyboardHideObserver: NSObjectProtocol?

    init() {
        keyboardShowObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.currentHeight = keyboardSize.height
            }
        }

        keyboardHideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.currentHeight = 0
        }
    }

    deinit {
        if let observer = keyboardShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = keyboardHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    @State private var authenticationFailed = false
    @State private var authenticationErrorMessage: String = ""
    @State private var navigateToMapView = false // To control navigation
    @ObservedObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) { // Adjust alignment and spacing as needed
                Text("Login")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)

                CustomTextField(title: "Email", text: $loginViewModel.username, keyboardType: .emailAddress)
                    .cornerRadius(5)
                
                CustomTextField(title: "Password", text: $loginViewModel.password, isSecure: true)
                    .cornerRadius(5)
                
                GreenButton(title: "Login", action: {
                    loginViewModel.login { success, errorMessage in
                        if success {
                            print("Login successful")
                            navigateToMapView = true
                        } else {
                            authenticationFailed = true
                            authenticationErrorMessage = errorMessage ?? "An error occurred"
                            print(errorMessage ?? "Login failed")
                        }
                    }
                })
                .disabled(loginViewModel.username.isEmpty || loginViewModel.password.isEmpty)
                
                // Place the NavigationLink outside the main VStack for better control
                NavigationLink(destination: MapView2(), isActive: $navigateToMapView) { EmptyView() }
            }
            .padding()
            .background(Color.white) // Set the entire VStack's background to white
            .cornerRadius(10)
            .padding(.bottom, keyboardResponder.currentHeight) // Adjust for keyboard
            .navigationBarHidden(true) // Optionally hide the navigation bar
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Align content to the top
            .background(Color.white.edgesIgnoringSafeArea(.all)) // Ensure the whole screen background is white
        }
    }
}

struct Login_View_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        LoginView()
    }
}

