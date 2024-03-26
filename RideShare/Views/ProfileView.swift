//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 21/03/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var viewModel = FormViewModel()
    @State private var isShowingImagePicker = false
    @State private var selectedTab = 0
    var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Descripción")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    if let userProfile = viewModel.userProfile {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ProfileTextFiles(label: "Nombre", value: userProfile.name)
                            ProfileTextFiles(label: "Rating", value: String(format: "%.1f", userProfile.rating ?? ""))
                            ProfileTextFiles(label: "Tipo de pago preferido", value: userProfile.payment ?? "Not assigned")
                        }
                        .padding(.horizontal)
                    }

                    if let image = viewModel.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 100)
                            .padding(.top, 20)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 200, height: 100)
                            .padding(.top, 20)
                    }

                    HStack(spacing: 20) {
                        Button("Seleccionar Imagen") {
                            self.isShowingImagePicker.toggle()
                        }
                        .padding()
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(image: $viewModel.profileImage, sourceType: .photoLibrary)
                        }

                        Button("Tomar Foto") {
                            viewModel.selectImage(sourceType: .camera)
                        }
                        .padding()
                    }

                    VStack(spacing: 20) {
                        Text("Datos del Vehículo")
                            .font(.title)
                            .fontWeight(.bold)

                        ForEach(viewModel.vehicles, id: \.self) { vehicle in
                            VStack(alignment: .leading, spacing: 10) {
                                ProfileTextFiles(label: "Type", value: vehicle.type)
                                ProfileTextFiles(label: "Plate", value: vehicle.plate)
                                ProfileTextFiles(label: "Referencia", value: vehicle.reference)
                                ProfileTextFiles(label: "Color", value: vehicle.color)
                            }
                            .padding(.horizontal)
                        }

                        
                    }
                    .padding(.bottom)
                    
                    GreenButton(title: "Registrar nuevo vehículo") {
                        // Action for registering a new vehicle
                    }
                    .padding()
                }
                .onAppear {
                            viewModel.fetchUserData() // Fetch user data when the view appears
                        }
                
            }
            
        }
}


//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
