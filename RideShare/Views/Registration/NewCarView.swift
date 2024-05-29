//
//  NewCarView.swift
//  RideShare
//
//  Created by Pablo Junco on 22/03/24.
//

import Foundation
import SwiftUI
struct NewCarView: View {
    @StateObject var viewModel = NewCarViewModel()
    @ObservedObject private var connectivityManager = ConnectivityManager.shared

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationDialog = false
    @State var navigateToProfileView = false
    
    var onVehicleAdded: () -> Void // Callback when a vehicle is added
    
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 20) {
                Text("Vehicle Form")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            
                
                Form {
                    Section {
                        CustomTextField(title: "Select Vehicle Type", text: $viewModel.vehicleType, backgroundColor: .clear, isPicker: true, pickerOptions: viewModel.vehicleTypes)
                        
                        Text("Type plate:")
                        CustomPlateTextField(text: $viewModel.plate, title: "AAA123")
                                    
                        Text("Enter vehicle reference:")
                        CustomTextField(title: "Vehicle Reference", text: $viewModel.reference, backgroundColor: .clear)
                        
                        CustomTextField(title: "Select Vehicle Color", text: $viewModel.vehicleColor, backgroundColor: .clear, isPicker: true, pickerOptions: viewModel.vehicleColors)
                    }
                    .padding(.vertical, 5)
                    .listRowBackground(Color.white)
                }
                .frame(height: 330)
                .background(Color.white)
                .padding(.horizontal, -30)
                
                
                GreenButton(tittle: "Register new vehicle") {
                    if connectivityManager.isConnected {
                        showConfirmationDialog = true
                    } else {
                        alertMessage = "No internet connection available. Please connect to the internet to continue."
                        showAlert = true
                    }
                }
                .disabled(!viewModel.isFormValid)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Connection Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .confirmationDialog("Are you sure you want to register this vehicle?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                    Button("Register", role: .destructive) {
                        viewModel.registerVehicle()
                    }
                    .foregroundColor(.green)
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This will add a new vehicle to your profile.")
                }
                
                
                NavigationLink(destination: Tabvar(startingTab: .account), isActive: $navigateToProfileView) { EmptyView() }
                Spacer()
            }
            .padding(.vertical)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Registration"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))}
        .navigationBarBackButtonHidden(true) // Hide the back button
        .onReceive(viewModel.$showAlert) { showAlert in
            if showAlert && viewModel.alertMessage == "Vehicle registered successfully." {
                self.navigateToProfileView = true
                onVehicleAdded() // Call the callback to notify of successful addition
            }
        }
    }
}

