//
//  ActivityViewModel.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 28/05/24.
//

import Foundation

class ActiveTripsViewModel: ObservableObject {
    @Published var passengerTrips: [ActiveTrips] = []
    @Published var driverTrips: [ActiveTrips] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let passengerTripsCacheKey = "PassengerTripsCache"
    private let driverTripsCacheKey = "DriverTripsCache"

    init() {
        // Cargar los viajes guardados en caché al inicializar el ViewModel
        loadCachedTrips()
    }

    func fetchActiveTripsForCurrentUser() {
        guard let currentUserUID = SessionManager.shared.currentUserProfile?.uid else {
            self.errorMessage = "No user currently authenticated."
            return
        }

        isLoading = true
        FirestoreManager.shared.fetchActiveTripsForUser(driverID: currentUserUID) { [weak self] trips, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Failed to fetch trips: \(error.localizedDescription)"
                } else {
                    // Separar los viajes en pasajero y conductor
                    if let trips = trips {
                        self?.passengerTrips = trips.filter { $0.passengers.contains(currentUserUID) }
                        self?.driverTrips = trips.filter { $0.driver_id == currentUserUID }
                        // Guardar los viajes en caché
                        self?.saveTripsToCache()
                    }
                }
            }
        }
    }

    private func saveTripsToCache() {
        do {
            let passengerTripsData = try JSONEncoder().encode(passengerTrips)
            UserDefaults.standard.set(passengerTripsData, forKey: passengerTripsCacheKey)

            let driverTripsData = try JSONEncoder().encode(driverTrips)
            UserDefaults.standard.set(driverTripsData, forKey: driverTripsCacheKey)
        } catch {
            print("Error saving trips to cache: \(error.localizedDescription)")
        }
    }

    private func loadCachedTrips() {
        // Cargar viajes de pasajero desde caché
        if let passengerTripsData = UserDefaults.standard.data(forKey: passengerTripsCacheKey) {
            do {
                let trips = try JSONDecoder().decode([ActiveTrips].self, from: passengerTripsData)
                passengerTrips = trips
            } catch {
                print("Error loading cached passenger trips: \(error.localizedDescription)")
            }
        }

        // Cargar viajes de conductor desde caché
        if let driverTripsData = UserDefaults.standard.data(forKey: driverTripsCacheKey) {
            do {
                let trips = try JSONDecoder().decode([ActiveTrips].self, from: driverTripsData)
                driverTrips = trips
            } catch {
                print("Error loading cached driver trips: \(error.localizedDescription)")
            }
        }
    }
}
