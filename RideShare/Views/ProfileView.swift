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
                                    self.imagePickerSourceType = .photoLibrary
                                    self.isShowingImagePicker = true
                                })
                                .padding(.horizontal, 30)
                                
                                BlueButton(title: "Take picture", action: {
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
                            viewModel.removeVehicle(at: index)
                        }
                        .padding(.horizontal, 30)
                    } else {
                        Text("(Selecciona un vehículo para ver los detalles)")
                    }
                }
                
                if viewModel.vehicles.count < 3 {
                    GreenButton(tittle: "Añadir Vehiculo") {
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
                viewModel.fetchUserData()
            }
        }
    }
}

struct VehicleImageView: View {
    @StateObject private var loader = AsyncImageLoader()
    var vehicle: Vehicle
    var index: Int
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        Group {
            if let urlString = vehicle.image, !urlString.isEmpty {
                if let imageData = loader.imageData, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if viewModel.isUploadingImage {
                    ProgressView()
                        .aspectRatio(contentMode: .fit)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .overlay(
                            Text("\(index + 1)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        )
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .overlay(
                        Text("\(index + 1)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )
            }
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            if let urlString = vehicle.image, !urlString.isEmpty {
                loader.loadImage(from: urlString)
            }
        }
        .onChange(of: vehicle.image) { newImageUrl in
            if let newImageUrl = newImageUrl, !newImageUrl.isEmpty {
                loader.loadImage(from: newImageUrl)
            }
        }
    }
}

struct VehicleDetailsView: View {
    var vehicle: Vehicle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProfileTextFiles(label: "Type", value: vehicle.type)
            ProfileTextFiles(label: "Plate", value: vehicle.plate)
            ProfileTextFiles(label: "Referencia", value: vehicle.reference)
            ProfileTextFiles(label: "Color", value: vehicle.color)
        }
        .padding(.horizontal)
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(mock: true))
    }
}
