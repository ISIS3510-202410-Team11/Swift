//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Sebastian Pedraza on 21/03/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var viewModel = ProfileViewModel()
    @ObservedObject private var connectivityManager = ConnectivityManager.shared
    @ObservedObject private var sessionManager = SessionManager.shared
    @State private var isShowingNewCarView = false
    @State private var isShowingImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // State for showing the alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showConfirmationDialog = false
    @State private var vehicleIndexToRemove: Int?

    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Your Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                if let userProfile = sessionManager.currentUserProfile {
                    Button(action: {
                        let newRole = !sessionManager.isDriver
                        if connectivityManager.isConnected {
                            sessionManager.updateRole(isDriver: newRole)
                        } else {
                            alertMessage = "No internet connection is available. Please connect to the internet to continue."
                            showAlert = true
                        }
                    }) {
                        Text(sessionManager.isDriver ? "Switch to Rider" : "Switch to Driver")
                            .foregroundColor(.white)
                            .padding()
                            .background(sessionManager.isDriver ? Color.blue : Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Connection Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        ProfileTextFiles(label: "Name", value: userProfile.name)
                        ProfileTextFiles(label: "Rating", value: userProfile.rating ?? "0.0")
                        ProfileTextFiles(label: "Preferred payment method", value: userProfile.payment ?? "Not assigned")
                    }
                    .padding(.horizontal)
                }
                if sessionManager.isDriver {
                    VStack(spacing: 20) {
                        Text("Vehicles")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Array(viewModel.vehicles.enumerated()), id: \.element) { index, vehicle in
                                    VehicleImageView(vehicle: vehicle, index: index, viewModel: viewModel)
                                        .onTapGesture {
                                            self.viewModel.selectedVehicleIndex = index
                                        }
                                }
                            }
                        }
                        .frame(height: 120)
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        
                        if let index = viewModel.selectedVehicleIndex {
                            VehicleDetailsView(vehicle: viewModel.vehicles[index])
                            
                            if viewModel.vehicles[index].image == nil || viewModel.vehicles[index].image?.isEmpty == true {
                                HStack {
                                    BlueButton(title: "Choose picture", action: {
                                        ClickCounter.shared.incrementCount()
                                        self.imagePickerSourceType = .photoLibrary
                                        self.isShowingImagePicker = true
                                    })
                                    .padding(.horizontal, 30)
                                    
                                    BlueButton(title: "Take picture", action: {
                                        ClickCounter.shared.incrementCount()
                                        self.imagePickerSourceType = .camera
                                        self.isShowingImagePicker = true
                                    })
                                    .padding(.horizontal, 30)
                                }
                                .sheet(isPresented: $isShowingImagePicker) {
                                    ImagePickerView(sourceType: self.imagePickerSourceType) { image in
                                        viewModel.updateVehicleImage(for: index, with: image)
                                    }
                                }
                            }
                            
                            RedButton(title: "Eliminar Vehiculo") {
                                if connectivityManager.isConnected {
                                    vehicleIndexToRemove = index
                                    showConfirmationDialog = true
                                } else {
                                    alertMessage = "No internet connection available. Please connect to the internet to continue."
                                    showAlert = true
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Connection Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
                            .confirmationDialog("Are you sure you want to delete this vehicle?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                                Button("Delete", role: .destructive) {
                                    if let index = vehicleIndexToRemove {
                                        viewModel.removeVehicle(at: index)
                                        vehicleIndexToRemove = nil // Reset the index after use
                                    }
                                }
                                Button("Cancel", role: .cancel) {}
                            } message: {
                                Text("This action cannot be undone.")
                            }
                            .padding(.horizontal, 30)
                        } else {
                            Text("(Selecciona un vehículo para ver los detalles)")
                        }
                    }
                    
                    if viewModel.vehicles.count < 3 {
                        GreenButton(tittle: "Añadir Vehiculo") {
                            ClickCounter.shared.incrementCount()
                            self.isShowingNewCarView = true
                        }
                        .padding(.horizontal, 30)
                        .sheet(isPresented: $isShowingNewCarView) {
                            NewCarView(onVehicleAdded: {
                                self.viewModel.fetchUserData()
                                self.isShowingNewCarView = false
                            })
                        }
                    }
                }
            }
            .onAppear {
                if !viewModel.isDataLoaded{
                    viewModel.checkConnectivityAndFetchData()
                }
            }
        }
    }
}







//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(viewModel: ProfileViewModel(mock: true))
//    }
//}
