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
import FirebaseFirestore

class RidePickerViewModel: NSObject, ObservableObject{
    //vars
    @Published var activeTrips: [ActiveTrips] = []
    @Published var selectedLocation: String?
    @Published var showAlert = false
    @Published var loadingBool = true
    private var db = Firestore.firestore()
    private var isCheckingDatabase = false

    
    func updateSelectedLocation(_ location: String) {
        selectedLocation = location
        //print("DEBUG: Selected Location from ridePicker is: \(selectedLocation ?? "Not working")")
    }
    func fetchData3(){
        print("DEBUG: Type: RIDE PICKER FETCH")
        
        
        guard let uid = SessionManager.shared.currentUserProfile?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("active_trips").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("DEBUG: No documents")
                return
            }
            //each document = documentSnapShot
            self.activeTrips = documents.map{(queryDocumentSnapshot) -> ActiveTrips in
                //dicc
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? "ID"
                let driver_id = data["driver_id"] as? String ?? "DRIVER_ID"
                let end_location = data["end_location"] as? String ?? "END_LOCATION"
                let estimated_fare = data["estimated_fare"] as? String ?? "4000"
                let passengers = data["passengers"] as? [String] ?? ["PASSENGER1","PASSENGER2"]
                let route = data["route"] as? [String] ?? ["ROUTE1","ROUTE2"]
                let start_location = data["start_location"] as? String ?? "START_LOCATION"
                let start_time = data["start_time"] as? String ?? "START_TIME"
                
                return ActiveTrips(id: id, estimated_fare: estimated_fare, driver_id: driver_id, end_location: end_location, passengers: passengers, route: route, start_location: start_location, start_time: start_time)
            }
        }
    }
    
    // NEW METHODS FOR ASYNC CHECK
    func startCheckingDatabase() {
        isCheckingDatabase = true
        checkDatabasePeriodically()
    }

    func stopCheckingDatabase() {
        isCheckingDatabase = false
    }

    private func checkDatabasePeriodically() {
        guard isCheckingDatabase else { return }

        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.fetchData()
            self?.checkDatabasePeriodically()
        }
    }
    
    func fetchData() {
        guard let uid = SessionManager.shared.currentUserProfile?.uid else {
            print("User not logged in")
            return
        }
        
        db.collection("active_trips").whereField("end_location", isEqualTo: self.selectedLocation).getDocuments { querySnapshot, error in
            if let error = error {
                print("DEBUG: Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("DEBUG: No documents")
                return
            }
            
            let activeTrips = documents.map { queryDocumentSnapshot -> ActiveTrips in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? String ?? "ID"
                let driver_id = data["driver_id"] as? String ?? "DRIVER_ID"
                let end_location = data["end_location"] as? String ?? "END_LOCATION"
                let estimated_fare = data["estimated_fare"] as? String ?? "4000"
                let passengers = data["passengers"] as? [String] ?? ["PASSENGER1", "PASSENGER2"]
                let route = data["route"] as? [String] ?? ["ROUTE1", "ROUTE2"]
                let start_location = data["start_location"] as? String ?? "START_LOCATION"
                let start_time = data["start_time"] as? String ?? "START_TIME"
                
                return ActiveTrips(id: id, estimated_fare: estimated_fare, driver_id: driver_id, end_location: end_location, passengers: passengers, route: route, start_location: start_location, start_time: start_time)
            }
            
            DispatchQueue.main.async {
                if documents.isEmpty{
                    self.showAlert = true
                    self.loadingBool = false
                    self.activeTrips = []
                }
                else{
                    self.loadingBool = false
                    self.activeTrips = activeTrips
                }
                
            }
        }
    }
    
}
/*
 Use dispatch.main to update UI
 Publishing changes from background threads is not allowed;
 make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
 */
