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
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = viewModel.profileImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200).offset(y:20)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
                    .frame(width: 200, height: 200).offset(y:20)
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

            Button("Guardar") {
                viewModel.saveFormData()
            }
            .padding().offset(y:-35)

            VStack(spacing: 20) {
                Text("Datos de Perfil").font(.title).fontWeight(.bold)

                HStack {
                        Text("Nombre:")
                        TextField("Nombre", text: $viewModel.userModel.name).padding().textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Cedula:")
                    TextField("Cedula", value: $viewModel.userModel.cedula, formatter: NumberFormatter()) // Corregido: debería ser .cedula
                        .padding().textFieldStyle(RoundedBorderTextFieldStyle())
                }

                HStack {
                    Text("Rating:")
                    TextField("Rating", value: $viewModel.userModel.rating, formatter: NumberFormatter())
                        .padding().textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Tipo de pago preferido:")
                    Picker(selection: $viewModel.userModel.paymentMethod, label: Text("Tipos de pagos"))
                        {
                            ForEach(viewModel.paymentMethods, id: \.self)
                            { method in Text(method)}
                        }
                    }
                .padding()
            }
        }
        .padding()
    }
}



struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
