//
//  NewTripViewModel.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 24/04/24.
//

import Foundation
import SwiftUI

class NewTripViewModel: ObservableObject {
    @Published var departureLocation: String = ""
    @Published var destinationLocation: String = ""
    @Published var numberOfPassengers: String = ""
    @Published var selectedVehicle: String = ""
    @Published var tripDate: Date = Date()
    @Published var tripTime: Date = Date()
    @Published var price: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let passengerNumbers: [String] = ["1", "2", "3", "4", "5", "6"]
    let vehicleOptions: [String] = ["Car", "Truck", "Motorcycle", "Bicycle"]
    
    func createTrip() {
    }
    
    private func resetForm() {
    }
    
    var isFormValid: Bool {
            !departureLocation.isEmpty &&
            !destinationLocation.isEmpty &&
            !numberOfPassengers.isEmpty &&
            !selectedVehicle.isEmpty &&
            !price.isEmpty
        }
    
    
}
