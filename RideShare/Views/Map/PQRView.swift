//
//  PQRView.swift
//  RideShare
//
//  Created by Cristian Caro on 21/05/24.
//

import SwiftUI
import Foundation

struct PQRView: View {
    @ObservedObject private var viewModel = PQRViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Type of PQR")) {
                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(PQRViewModel.PQRType.allCases) { type in
                            Text(type.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Comments")) {
                    TextEditor(text: $viewModel.comment)
                        .frame(minHeight: 200)
                }
                Section {
                    GreenButton(tittle: "Submit PQR"){
                        AnalyticsManager.shared.logEvent(name: "BQ2_2", params: ["PQRView":"Submit \($viewModel.selectedType)"])
                        AnalyticsManager.shared.logEvent(name: "BQ2_3", params: ["PQRView":"Comment \($viewModel.comment)"])
                        viewModel.submitPQR()
                    }
                }
            }
            .padding(.bottom)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("No Internet Connection"),
                    message: Text("Please check your internet connection and try again."),
                    dismissButton: .default(Text("Accept"))
                )
            }
            .background(Color.white)
            .navigationTitle("PQR")
        }
    }
}

#Preview {
    PQRView()
}
