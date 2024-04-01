//
//  LoginViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import Combine
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    // Login logic using Firebase Authentication
    func login(completion: @escaping (Bool, String?) -> Void) {
            Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false, error.localizedDescription)
                    } else if let user = authResult?.user {

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
    }
