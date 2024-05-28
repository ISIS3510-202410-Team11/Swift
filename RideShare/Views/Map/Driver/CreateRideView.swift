//
//  CreateRide.swift
//  RideShare
//
//  Created by Pablo Junco on 6/05/24.
//

import Foundation
import SwiftUI

struct CreateRideView: View {
    @State private var destination: String = ""
    @State private var estimatedFare: String = ""
    @State private var departureTime: Date = Date()
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    
    @Binding var mapState: MapViewState
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var createRideViewModel = CreateRideViewModel()
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {
        VStack {
            Text("Create a New Ride")
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Divider()
            
            Form {
                TextField("Enter Destination", text: $destination)
                    .onAppear {
                        // Set initial destination from the view model
                        if let location = viewModel.selectedLocation{
                            
                            
                            createRideViewModel.updatedLocation(location.title)
                            
                            destination = location.title
                            print("Picked destination is: \(destination)")
                            createRideViewModel.updatedInstructions(viewModel.instructions)
                            print("Instructions for this ride: \(viewModel.instructions)")
                        }
                        
                    }
                TextField("Estimated Fare ($)", text: $estimatedFare)
                    .keyboardType(.decimalPad)
                DatePicker("Departure Time", selection: $departureTime, displayedComponents: .hourAndMinute)
                
                Button("Create Ride") {
                    if !networkManager.isConnected {
                        alertMessage = "No internet connection available. Please connect to the internet to continue."
                        showAlert = true
                    } else {
                        createRide()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .background(Color.white)
    }
    
    private func createRide() {
        guard validateFare(estimatedFare) else {
            alertMessage = "Please enter a valid fare amount."
            showAlert = true
            return
        }
        
        print("Creating ride to \(destination) with fare $\(estimatedFare) at \(departureTime)")
        // Transition to the next appropriate view state
        actionState(mapState)
    }
    
    private func validateFare(_ fare: String) -> Bool {
        guard let fareValue = Double(fare), fareValue > 0 else {
            return false
        }
        return true
    }
    
    func actionState(_ state: MapViewState) {
        // Assuming the state should change to another specific state after ride creation
        if state == .locationSelected {
            mapState = .noInput
        }
    }
}

