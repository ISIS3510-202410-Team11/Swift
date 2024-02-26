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

    // Add your login logic here
    func login(completion: @escaping (Bool) -> Void) {
        // Here, you would usually interact with a web service to authenticate the user.
        // For this example, we're just simulating a successful login after a delay.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Simulate login success
            completion(true)
        }
    }
}
