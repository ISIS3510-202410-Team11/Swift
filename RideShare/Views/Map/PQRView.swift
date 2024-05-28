//
//  PQRView.swift
//  RideShare
//
//  Created by Cristian Caro on 21/05/24.
//

import SwiftUI

struct PQRView: View {
    @StateObject private var viewModel = PQRViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Tipo de PQR")) {
                    Picker("Tipo", selection: $viewModel.selectedType) {
                        ForEach(PQRViewModel.PQRType.allCases) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Comentario")) {
                    TextEditor(text: $viewModel.comment)
                        .frame(minHeight: 200)
                }
                
                Section {
                    Button("Enviar PQR") {
                        viewModel.submitPQR()
                    }
                }
            }
            .navigationBarTitle("Registrar PQR")
        }
    }
}

#Preview {
    PQRView()
}
