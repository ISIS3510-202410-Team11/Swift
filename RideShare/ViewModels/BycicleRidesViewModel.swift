//
//  BycicleRidesViewModel.swift
//  RideShare
//
//  Created by Pablo Junco on 29/05/24.
//

import Foundation
import Combine

class BicycleRidesViewModel: ObservableObject {
    @Published var bicycleRides: [BicycleRide] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchBicycleRides()
    }
    
    func fetchBicycleRides() {
        FirestoreManager.shared.fetchBicycleRides { [weak self] rides in
            DispatchQueue.main.async {
                self?.bicycleRides = rides
            }
        }
    }
}
