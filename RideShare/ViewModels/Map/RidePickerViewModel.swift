//
//  RidePickerViewModel.swift
//  RideShare
//
//  Created by Cristian Caro on 4/05/24.
//

import Foundation
import Network
import SwiftUI
import Combine

class RidePickerViewModel: NSObject, ObservableObject{
    //vars
    @Published var activeTrips: [ActiveTrips] = []
    @Published var selectedLocation: String?
    //init
    override init() {
        super.init()
        //fetchActiveTripsData()
        load()
    }
    func load(){
        Task(priority: .medium){
            print("DEBUG: RIDE PICKERRR")
            await fetchActiveTripsData()
        }
    }
    func fetchActiveTripsData() async {
        do {
            //imprimir variable de entorno
            //print("DEBUG: Location selected is: \(locationViewModel.selectedLocation?.title)")
            let rides = try await FirestoreManager.shared.fetchActiveTripsData()
            DispatchQueue.main.async { // Communicate with main thread so he publishes
                self.activeTrips = rides
            }
        } catch {
            print("Error fetching active trips data: \(error)")
        }
    }
    func fetchActiveTripsDataFiltered(){
        //print("DEBUG: Selected location inside is: \(selectedLocation)")
        FirestoreManager.shared.fetchActiveTripsDataFiltered(location: self.selectedLocation ?? "None"){ [weak self] rides, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching active trips data: \(error)")
                    return
                }
                if let rides = rides {
                    self.activeTrips = rides
                } else{
                    self.activeTrips = []
                }
            }
        }
    }
    func updateSelectedLocation(_ location: String) {
        selectedLocation = location
        //print("DEBUG: Selected Location from ridePicker is: \(selectedLocation ?? "Not working")")
    }
}
/*
 Use dispatch.main to update UI
 Publishing changes from background threads is not allowed;
 make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
 */
