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
            VStack(spacing: 20) {
                Text("Descripción")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 10) {
                    ProfileTextFiles(label: "Nombre", value: viewModel.userModel.name)
                    ProfileTextFiles(label: "Rating", value: "\(viewModel.userModel.rating)")
                    ProfileTextFiles(label: "Tipo de pago preferido", value: viewModel.userModel.paymentMethod)
                }
                .padding(.horizontal)
                
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
                    
                    ProfileTextFiles(label: "Type", value: "Hola")
                    ProfileTextFiles(label: "Plate", value: "Hola")
                    ProfileTextFiles(label: "Referencia", value: "Hola")
                    ProfileTextFiles(label: "Color", value: "Rojo agua marina")
                    
                    Button("Registrar nuevo vehículo") {
                        
                    }
                    .padding()
                }
                .padding()
        }
    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
