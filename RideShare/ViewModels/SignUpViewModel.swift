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
    
    // Optional userSession property, can be set after ViewModel initialization
    var userSession: UserSession?

    init() {
        // Initializer no longer requires userSession
    }
    
    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                } else if let user = authResult?.user {
                    self?.alertMessage = "Registration successful. Welcome, \(self?.name ?? "")!"
                    self?.showAlert = true
                    
                    // Assuming User conforms to Codable
                    let newUser = User(uid: user.uid, name: self?.name ?? "", email: self?.email ?? "", driver: self?.isDriver ?? false, newsletter: self?.wantsNewsletter ?? false)
                    
                    // Make sure userSession exists before attempting to set UID
                    self?.userSession?.uid = newUser.uid
                    
                    // Saving user info in Firestore or your preferred database
                    FirestoreManager.shared.addUser(user: newUser) { err in
                        if let err = err {
                            self?.alertMessage = "Failed to save user info: \(err.localizedDescription)"
                            self?.showAlert = true
                        } else {
//                            self?.alertMessage = "User info saved successfully."
                            self?.showAlert = true
                            self?.registrationSuccessful = true
                        }
                    }
                }
            }
        }
    }

    var isFormValid: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
}
