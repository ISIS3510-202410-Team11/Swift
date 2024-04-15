//
//  LoginViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import Combine
import FirebaseAuth
import KeychainAccess
import LocalAuthentication

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated = false
    @Published var authenticationFailed = false
    @Published var authenticationErrorMessage: String = ""
    
    private let keychain = Keychain(service: "com.jp.junco.Moviles.RideShareV2")
    
    // Login logic using Firebase Authentication
    func login(completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    self?.authenticationFailed = true
                    self?.authenticationErrorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                } else if let user = authResult?.user {
                    print("Login successful, user ID: \(user.uid)")
                    self?.storeCredentials()
                    SessionManager.shared.fetchUserProfile(uid: user.uid)
                    completion(true, nil)
                }
            }
        }
    }
    
    func recoverPassword(for email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    // If the email was sent successfully, pass true and nil for the error message
                    completion(true, nil)
                }
            }
        }
    }
    
    
    private func storeCredentials() {
        do {
            try keychain
                .accessibility(.whenUnlockedThisDeviceOnly)
                .set(password, key: username)
            print("Credentials stored successfully in Keychain")
        } catch let error {
            print("Error storing to keychain: \(error)")
            self.authenticationFailed = true
            self.authenticationErrorMessage = "Failed to store credentials securely."
            
            print("Error storing credentials in Keychain: \(error)")
        }
    }
    
    func authenticateUserUsingFaceID(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Face ID to access your account securely."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.useCredentialsForLogin(completion: completion)
                    } else {
                        print("Face ID authentication failed: \(String(describing: authenticationError))")
                        completion(false, authenticationError)
                    }
                }
            }
        } else {
            print("Face ID not available: \(String(describing: error))")
            completion(false, error)
        }
    }
    
    private func useCredentialsForLogin(completion: @escaping (Bool, Error?) -> Void) {
        guard let password = try? keychain.get(username) else {
            print("No credentials available in Keychain for username: \(username)")
            completion(false, nil)
            return
        }
        Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let user = authResult?.user {
                    print("Successfully authenticated with Face ID for user: \(user.uid)")
                    SessionManager.shared.fetchUserProfile(uid: user.uid)
                    completion(true, nil)
                } else if let error = error {
                    print("Authentication using stored credentials failed: \(error.localizedDescription)")
                    self?.authenticationFailed = true
                    self?.authenticationErrorMessage = error.localizedDescription
                    completion(false, error)
                }
            }
        }
    }
    
    
    
}
