//
//  RideStatusViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 28/05/24.
//

import Foundation
import Combine
class RideStatusViewModel: ObservableObject {
    @Published var destination: String = ""
    @Published var selectedLocation: String?
    
    @Published var passengers: [Passenger] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func updatedLocation(_ location: String) {
        self.selectedLocation = location
        self.destination = location
        print("selected from create ride is: \(selectedLocation ?? "null") ")
    }
    
    func listenForPassengersUpdates(rideId: String) {
            guard !rideId.isEmpty else {
                print("Error: rideId is empty")
                return
            }
            
            FirestoreManager.shared.listenForPassengersUpdates(rideId: rideId) { [weak self] passengers in
                DispatchQueue.main.async {
                    self?.passengers = passengers
                }
            }
        }
}

