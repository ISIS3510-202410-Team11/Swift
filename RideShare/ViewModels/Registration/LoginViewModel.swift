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
                    KeychainHelper.storeData(email: self?.username ?? "", password: self?.password ?? "")
                    SessionManager.shared.fetchUserProfile(uid: user.uid)
                    completion(true, nil)
                }
            }
        }
    }
    
    func recoverPassword(for email: String, completion: @escaping (Bool, String?) -> Void) {
        KeychainHelper.deleteAllCredentials()
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
    
    
    func authenticateUserUsingFaceID(completion: @escaping (Bool, String?) -> Void) {
            let context = LAContext()
            var error: NSError?


            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate using Face ID to access your account"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            
                            self?.loginWithKeychainCredentials(completion: completion)
                        } else {

                            print("Face ID authentication failed: \(String(describing: authenticationError))")
                            self?.authenticationFailed = true
                            self?.authenticationErrorMessage = authenticationError?.localizedDescription ?? "Failed to authenticate using Face ID"
                            completion(false, self?.authenticationErrorMessage)
                        }
                    }
                }
            } else {

                print("Face ID not available or configured: \(String(describing: error))")
                authenticationFailed = true
                authenticationErrorMessage = error?.localizedDescription ?? "Face ID not available or configured"
                completion(false, authenticationErrorMessage)
            }
        }

        private func loginWithKeychainCredentials(completion: @escaping (Bool, String?) -> Void) {

            let credentials = KeychainHelper.retrieveCredentials()
            if let email = credentials.email, let password = credentials.password {

                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Login error with Keychain credentials: \(error.localizedDescription)")
                            self?.authenticationFailed = true
                            self?.authenticationErrorMessage = error.localizedDescription
                            completion(false, error.localizedDescription)
                        } else if let user = authResult?.user {
                            print("Login successful with Keychain, user ID: \(user.uid)")
                            SessionManager.shared.fetchUserProfile(uid: user.uid)
                            completion(true, nil)
                        }
                    }
                }
            } else {

                authenticationFailed = true
                authenticationErrorMessage = "You need to authenticate one time successfully to activate Face ID."
                completion(false, authenticationErrorMessage)
            }
        }
    
    
    
    
    
}
