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

    // Error messages for each field
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?

    private let emailPattern = "^[A-Za-z0-9._%+-]+@uniandes\\.edu\\.co$"

    // Real-time field validation methods
    func validateName() {
        if name.isEmpty {
            nameError = "Username cannot be blank"
        } else if name.count < 3 {
            nameError = "Username must be at least 3 characters"
        } else {
            nameError = nil
        }
    }

    func validateEmail() {
        if !isValidEmail(email) {
            emailError = "Email must be valid ('@uniandes.edu.co')"
        } else {
            emailError = nil
        }
    }

    func validatePassword() {
        if !isValidPassword(password) {
            passwordError = " 8 characters, uppercase letter, number"
        } else {
            passwordError = nil
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        return regex.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let regex = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return regex.evaluate(with: password)
    }

    func registerUser() {
        // Reset errors
        nameError = nil
        emailError = nil
        passwordError = nil

        // Validate fields before attempting to register
        if validateFields() {
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
    }

    // Validation before registration attempt
    private func validateFields() -> Bool {
        validateName()
        validateEmail()
        validatePassword()

        return nameError == nil && emailError == nil && passwordError == nil
    }

    var isFormValid: Bool {
        nameError == nil && emailError == nil && passwordError == nil
    }
}

