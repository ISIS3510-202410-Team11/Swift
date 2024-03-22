//
//  LoginView.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import SwiftUI

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
    @State private var user = User(name: "", email: "", password: "")
    @State private var isSignUpComplete = false
    @ObservedObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                CustomTextField(title: "Email", text: $user.email, keyboardType: .emailAddress)
                
                CustomTextField(title: "Password", text: $user.password, isSecure: true)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white) // Or any color to distinguish the form area
            .cornerRadius(10)

            Spacer()
            
            GreenButton(title: "Sign Up", action: {
                print("Performing sign-up...")
                isSignUpComplete = true
            })
            .disabled(!isFormValid)
            .padding()
            .padding(.bottom, keyboardResponder.currentHeight)
            .animation(.easeOut(duration: 0.16), value: keyboardResponder.currentHeight)
        }
        .edgesIgnoringSafeArea(keyboardResponder.currentHeight > 0 ? .bottom : [])
    }
    
    var isFormValid: Bool {
        !user.name.isEmpty && !user.email.isEmpty && !user.password.isEmpty
    }
}
struct Login_View_Preview: PreviewProvider {
    static var previews: some View {
        // Create a temporary binding for isAuthenticated
        // For preview purposes, we initialize it with false
        LoginView()
    }
}

