//
//  SignUpViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//
import Foundation
import FirebaseAuth


class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isDriver: Bool = false
    @Published var wantsNewsletter: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var registrationSuccessful: Bool = false
    
    
    func registerUser() {
            SessionManager.shared.registerUser(email: email, password: password, name: name, isDriver: isDriver, wantsNewsletter: wantsNewsletter) { success, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.showAlert = true
                        self.alertMessage = "Registration failed: \(error.localizedDescription)"
                    } else if success {
                        self.registrationSuccessful = true
                        self.showAlert = true
                        self.alertMessage = "Registration successful. Welcome, \(self.name)!"
                    }
                }
            }
        }

    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
}
