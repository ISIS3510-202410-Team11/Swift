//
//  NewCarViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 22/03/24.
//

import Foundation
import SwiftUI

class NewCarViewModel: ObservableObject {
    @Published var type: String = ""
    @Published var plate: String = ""
    @Published var reference: String = ""
    @Published var color: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func registerVehicle(userUID: String) {
        // Create a Vehicle instance
        let vehicle = Vehicle( type: type, plate: plate, reference: reference, color: color)
        
        // Use FirestoreManager to add the vehicle
        FirestoreManager.shared.addVehicle(forUserUID: userUID, vehicle: vehicle) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = "Failed to register vehicle: \(error.localizedDescription)"
                    self?.showAlert = true
                } else {
                    self?.alertMessage = "Vehicle registered successfully."
                    self?.showAlert = true
                    // Optionally reset form here
                }
            }
        }
    }
    
    // Example validation logic
    var isFormValid: Bool {
        !type.isEmpty && !plate.isEmpty && !reference.isEmpty && !color.isEmpty
    }
}
