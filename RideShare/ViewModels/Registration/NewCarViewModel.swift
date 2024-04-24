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
    
    @Published var vehicleColor: String = "Black" // Default or initial value
    
    @Published var vehicleType: String = "Car" // Default or initial value
    
    let vehicleTypes: [String] = ["Car", "Truck", "Motorcycle", "Bicycle"]
    
    
    let vehicleColors: [String] = ["White", "Black", "Gray",
                                   "Silver","Blue","Red","Brown",
                                   "Green", "Yellow"]
    
    func registerVehicle() {
        guard let userUID = SessionManager.shared.currentUserProfile?.uid else {
            self.alertMessage = "User not logged in."
            self.showAlert = true
            return
        }
        
        let vehicleID = UUID().uuidString
        let vehicle = Vehicle(id:vehicleID, type: vehicleType, plate: plate, reference: reference, color: vehicleColor)
        
        FirestoreManager.shared.addVehicle(forUserUID: userUID, vehicle: vehicle) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertMessage = "Failed to register vehicle: \(error.localizedDescription)"
                    self?.showAlert = true
                } else {
                    self?.alertMessage = "Vehicle registered successfully."
                    self?.showAlert = true

                    self?.resetForm()
                }
            }
        }
    }
    
    private func resetForm() {
        type = ""
        plate = ""
        reference = ""
        color = ""
    }
    
    var isFormValid: Bool {
        !plate.isEmpty && !reference.isEmpty
    }
}
