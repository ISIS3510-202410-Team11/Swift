//
//  LoginViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 27/02/24.
//

import Foundation
import Combine


class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    
    // Login logic here
    func login(completion: @escaping (Bool) -> Void) {
        // Interact with a web service to authenticate the user
        // Simulate a successful login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(true) // Simulated login success
        }
    }
}
