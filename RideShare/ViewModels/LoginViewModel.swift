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
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                    completion(false, error.localizedDescription)
                } else if authResult?.user != nil {
                    completion(true, nil) 
                }
            }
        }
    }
}
