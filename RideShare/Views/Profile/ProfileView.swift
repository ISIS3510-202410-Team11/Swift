//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Sebastian Pedraza on 21/03/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var viewModel = ProfileViewModel()
    @State private var isShowingNewCarView = false
    @State private var isShowingImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
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
                
                if let userProfile = viewModel.userProfile {
                    VStack(alignment: .leading, spacing: 10) {
                        ProfileTextFiles(label: "Name", value: userProfile.name)
                        ProfileTextFiles(label: "Rating", value: userProfile.rating ?? "0.0")
                        ProfileTextFiles(label: "Preferred payment method", value: userProfile.payment ?? "Not assigned")
                    }
                    .padding(.horizontal)
                }
                
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
                            ClickCounter.shared.incrementCount()
                            viewModel.removeVehicle(at: index)
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
