//
//  RegistrationViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 26/02/24.
//

import Combine
import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = "" // Registration might require more info than login
    
    @Published var navigateToSignUp: Bool = false

    // Registration logic here
    func signUp(completion: @escaping (Bool) -> Void) {
        // Interact with a web service to register the user
        // Simulate a successful registration
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(true) // Simulated registration success
        }
    }

}
