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
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func registerUser() {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.alertMessage = error.localizedDescription
                        self?.showAlert = true
                    } else if authResult?.user != nil {
                        self?.alertMessage = "Registration successful. Welcome, \(self?.name ?? "")!"
                        self?.showAlert = true
                        // Here you could also save the user's name and other details to Firestore or Realtime Database
                    }
                }
            }
        }
    
    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
}
