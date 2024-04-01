//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Pablo Junco on 21/03/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var viewModel = ProfileViewModel()

    @State private var isShowingNewCarView = false // State to control navigation
    
    @State private var isShowingImagePicker = false
    @State private var isTakingPhoto = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary


    
    init(viewModel: ProfileViewModel) {
            self.viewModel = viewModel
        }
    
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 20) {
                    Text("Tu Perfil")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    if let userProfile = viewModel.userProfile {
                        VStack(alignment: .leading, spacing: 10) {
                            ProfileTextFiles(label: "Nombre", value: userProfile.name)
                            ProfileTextFiles(label: "Rating", value: userProfile.rating ?? "")
                            ProfileTextFiles(label: "Tipo de pago preferido", value: userProfile.payment ?? "Not assigned")
                        }
                        .padding(.horizontal)
                    }

                    VStack(spacing: 20) {
                        Text("Vehículos")
                            .font(.title2)
                            .fontWeight(.bold)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(Array(viewModel.vehicles.enumerated()), id: \.element) { index, vehicle in
                                    VehicleImageView(vehicle: vehicle, index: index)
                                        .onTapGesture {
                                            self.viewModel.selectedVehicleIndex = index
                                        }
                                }
                            }
                        }
                        .frame(height: 120)
                        .padding(.vertical)
                        .padding(.horizontal,30)

                        if let index = viewModel.selectedVehicleIndex {
                            VehicleDetailsView(vehicle: viewModel.vehicles[index])
                            RedButton(title: "Eliminar Vehiculo") {
                                                    // Implement vehicle removal logic here
                                                    viewModel.removeVehicle(at: index)
                                                }
                                                .padding(.horizontal,30)
                        } else {
                            Text("(Selecciona un vehículo para ver los detalles)")
                        }
                    }
                    
                
                    if viewModel.vehicles.count < 3 {
                        GreenButton(title: "Añadir Vehiculo") {
                            self.isShowingNewCarView = true
                            
                        }
                        .padding(.horizontal,30)
                        .sheet(isPresented: $isShowingNewCarView) {
                            NewCarView(onVehicleAdded: {
                                self.viewModel.fetchUserData()
                                self.isShowingNewCarView = false
                            })
                        }
                    }
                    
                }
                .onAppear {
                    viewModel.fetchUserData() // Fetch user data when the view appears
                }
            }
            
        }
        
    }
}

struct VehicleImageView: View {
    var vehicle: Vehicle
    var index: Int
    
    var body: some View {
        if let imageData = vehicle.image, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            // Placeholder when image data is not available
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(width: 100, height: 100)
                .overlay(
                    Text("\(index + 1)")
                    .font(.largeTitle) // Adjust font size as needed
                    .foregroundColor(.white)
                )
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



// ProfileView_Previews with a mock FormViewModel
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(mock: true)) // Pass a mock viewModel instance
    }
}
