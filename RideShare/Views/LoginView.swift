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
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    CustomTextField(title: "Email", text: $loginViewModel.username, keyboardType: .emailAddress)
                    
                    CustomTextField(title: "Password", text: $loginViewModel.password, isSecure: true)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white) // Or any color to distinguish the form area
                .cornerRadius(10)

                Spacer()
                
                GreenButton(title: "Login", action: {
                    loginViewModel.login { success, errorMessage in
                        if success {
                            print("Login successful")
                            navigateToMapView = true // Trigger navigation
                        } else {
                            authenticationFailed = true
                            authenticationErrorMessage = errorMessage ?? "An error occurred"
                            print(errorMessage ?? "Login failed")
                        }
                    }
                }).disabled(loginViewModel.username.isEmpty || loginViewModel.password.isEmpty)
                .padding()
                .animation(.easeOut(duration: 0.16), value: keyboardResponder.currentHeight)
                .padding(.bottom, keyboardResponder.currentHeight)
                
//                Button(action: authenticateWithFaceID) {
//                    HStack {
//                        Image(systemName: "faceid")
//                            .font(.title)
//                        Text("Log In with Face ID")
//                            .fontWeight(.bold)
//                    }
//                }
//                .padding()
//                .background(Color.green) // Use your app's theme color
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .animation(.easeOut(duration: 0.16), value: keyboardResponder.currentHeight)
//                .padding(.bottom, keyboardResponder.currentHeight)
                
                // NavigationLink to proceed to the next view on successful login
                NavigationLink(destination: MapView2(), isActive: $navigateToMapView) { EmptyView() }
            }
            .edgesIgnoringSafeArea(keyboardResponder.currentHeight > 0 ? .bottom : [])
            // Optionally add .alert here to handle authenticationFailed
        }
    }
    
    
//    var isFormValid: Bool {
//        !user.name.isEmpty && !user.email.isEmpty && !user.password.isEmpty
//    }
    
//    func authenticateWithFaceID() {
//        let context = LAContext()
//        var error: NSError?
//        
//        // Check if Face ID is available
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "Log in using Face ID"
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                DispatchQueue.main.async {
//                    if success {
//                        // Face ID authentication was successful
//                        // Proceed with your login flow, e.g., setting isSignUpComplete to true
//                        self.isSignUpComplete = true
//                    } else {
//                        // Handle authentication failure
//                        // You can show an alert or update the UI accordingly
//                        print("Authentication failed")
//                    }
//                }
//            }
//        } else {
//            // Face ID not available or other error
//            // Handle this scenario gracefully in your app
//            print(error?.localizedDescription ?? "Face ID not available")
//        }
//    }
}

struct Login_View_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        LoginView()
    }
}

