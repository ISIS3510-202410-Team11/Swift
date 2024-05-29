//
//  CreateRideViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 28/05/24.
//

import Foundation
class CreateRideViewModel: ObservableObject {
    @Published var rideID: String = ""
    @Published var destination: String = ""
    @Published var estimatedFare: String = ""
    @Published var departureTime: Date = Date()
    @Published var showAlert = false
    @Published var alertMessage: String = ""
    
    @Published var startLocation: String = "ML"
    let possibleStartLocations = ["ML", "SD", "CityU"]
    
    @Published var selectedLocation: String?
    @Published var selectedInstructions: [String] = []

    func updatedLocation(_ location: String) {
        selectedLocation = location
        destination = location
        print("selected from create ride is: \(selectedLocation ?? "null") ")
    }

    func updatedInstructions(_ instructions: [String]) {
        selectedInstructions = instructions
        print("selected instructions: \(selectedInstructions)")
    }

    func createRide(completion: @escaping (Bool, String?) -> Void) {
        guard let userUID = SessionManager.shared.currentUserProfile?.uid else {
            completion(false, "User not logged in.")
            return
        }

        guard selectedLocation != nil else {
            completion(false, "Start location not set.")
            return
        }

        rideID = UUID().uuidString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let startTime = dateFormatter.string(from: departureTime)
        destination = selectedLocation ?? "not working"
        let rideData: [String: Any] = [
            "id": rideID,
            "driver_id": userUID,
            "start_location": startLocation,
            "end_location": selectedLocation ?? "null",
            "start_time": startTime,
            "passengers": [],  // initially empty
            "estimated_fare": estimatedFare,
            "route": selectedInstructions,
            
        ]

        FirestoreManager.shared.addRide(rideData: rideData) { success, error in
            if success {
                self.resetForm()
            }
            completion(success, error)
        }
    }

    private func resetForm() {
        destination = ""
        estimatedFare = ""
        departureTime = Date()
        selectedLocation = nil
        selectedInstructions = []
    }
}

