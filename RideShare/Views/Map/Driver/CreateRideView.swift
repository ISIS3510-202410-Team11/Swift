//
//  CreateRide.swift
//  RideShare
//
//  Created by Pablo Junco on 6/05/24.
//

import Foundation
import SwiftUI

struct CreateRideView: View {
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
                
                Picker("Select Start Location", selection: $createRideViewModel.startLocation) {
                    ForEach(createRideViewModel.possibleStartLocations, id: \.self) { location in
                        Text(location).tag(location)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Text("Destination: \(createRideViewModel.destination)")
                    .onAppear {
                        // Set initial destination from the view model
                        if let location = viewModel.selectedLocation {
                            createRideViewModel.updatedLocation(location.title)
                            createRideViewModel.updatedInstructions(viewModel.instructions)
                            print("Picked destination is: \(createRideViewModel.destination)")
                            print("Instructions for this ride: \(viewModel.instructions)")
                        }
                    }
                TextField("Estimated Fare ($)", text: $createRideViewModel.estimatedFare)
                    .keyboardType(.decimalPad)
                DatePicker("Departure Time", selection: $createRideViewModel.departureTime, displayedComponents: .hourAndMinute)
                
                GreenButton(tittle: "Create Ride") {
                    if !networkManager.isConnected {
                        createRideViewModel.alertMessage = "No internet connection available. Please connect to the internet to continue."
                        createRideViewModel.showAlert = true
                    } else {
                        createRide()
                    }
                }
            }
            .alert(isPresented: $createRideViewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(createRideViewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .padding(.top, 20)
        }
        .background(Color.white)
    }
    
    private func createRide() {
        guard validateFare(createRideViewModel.estimatedFare) else {
            createRideViewModel.alertMessage = "Please enter a valid fare amount."
            createRideViewModel.showAlert = true
            return
        }

        createRideViewModel.createRide { success, error in
            if success {
                print("Ride created successfully.")
                actionState(mapState)
            } else {
                createRideViewModel.alertMessage = error ?? "Failed to create ride."
                createRideViewModel.showAlert = true
            }
        }
    }
    
    private func validateFare(_ fare: String) -> Bool {
        guard let fareValue = Double(fare), fareValue > 0 else {
            return false
        }
        return true
    }
    
    func actionState(_ state: MapViewState) {
        if state == .locationSelected {
            mapState = .noInput
        }
    }
}
//#Preview {
//    CreateRideView(
//        mapState: .constant(.noInput),
//        networkManager: NetworkManager(),
//        createRideViewModel: CreateRideViewModel()
//    )
//    .environmentObject(LocationSearchViewModel())
//}
