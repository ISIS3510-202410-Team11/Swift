//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 22/04/24.
//

import SwiftUI

struct TripView: View {
    @StateObject var viewModel = NewTripViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Form {
                    Section(header: Text("Trip Details").font(.headline).frame(maxWidth: .infinity, alignment: .center)) {
                        CustomTextField(title: "Departure Location", text: $viewModel.departureLocation)
                            .padding(.vertical, 5) 
                        
                        CustomTextField(title: "Destination Location", text: $viewModel.destinationLocation)
                            .padding(.vertical, 5)
                        
                        CustomTextField(
                            title: "Number of Passengers",
                            text: $viewModel.numberOfPassengers,
                            isPicker: true,
                            pickerOptions: viewModel.passengerNumbers
                        )
                        .padding(.vertical, 5)
                        
                        CustomTextField(
                            title: "Select Vehicle",
                            text: $viewModel.selectedVehicle,
                            isPicker: true,
                            pickerOptions: viewModel.vehicleOptions
                        )
                        .padding(.vertical, 5)
                        
                        DatePicker(
                            "Select Date",
                            selection: $viewModel.tripDate,
                            displayedComponents: .date
                        )
                        .padding(.vertical, 5)
                        
                        DatePicker(
                            "Select Time",
                            selection: $viewModel.tripTime,
                            displayedComponents: .hourAndMinute
                        )
                        .padding(.vertical, 5)
                        
                        CustomTextField(title: "Price", text: $viewModel.price)
                            .keyboardType(.decimalPad)
                            .padding(.vertical, 5)
                        
                        GreenButton(tittle: "Create Trip") {
                            viewModel.createTrip()
                        }
                        .disabled(!viewModel.isFormValid)
                        .padding(.vertical, 5)
                    }
                }
                .frame(maxWidth: .infinity) // Usa el máximo ancho disponible
                Spacer() // Espacio en la parte inferior
            }
            .navigationBarTitle("New Trip", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                
            })
        }
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView()
    }
}





