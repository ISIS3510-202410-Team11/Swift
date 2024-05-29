//
//  ActivityView.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 28/05/24.
//
import SwiftUI

struct TripCardView: View {
    let trip: ActiveTrips

    var body: some View {
        HStack {
            Image(systemName: "car.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.trailing, 8)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 8) {
                Text("Start Location: \(trip.start_location)")
                    .font(.subheadline)
                    .padding(.leading, 8) // Ajuste del espaciado
                Text("Start Time: \(trip.start_time)")
                    .font(.subheadline)
                    .padding(.leading, 8) // Ajuste del espaciado
                Text("End Location: \(trip.end_location)")
                    .font(.subheadline)
                    .padding(.leading, 8) // Ajuste del espaciado

                HStack(spacing: 4) {
                    ForEach(trip.passengers.filter { $0.count > 3 }, id: \.self) { _ in
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 8) // Ajuste del espaciado
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}


struct ActiveTripsView: View {
    @ObservedObject private var viewModel = ActiveTripsViewModel()
    @State private var navigateToMapView = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading trips...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.passengerTrips.isEmpty && viewModel.driverTrips.isEmpty {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                            .padding(.bottom, 8)
                        Text("No trips available. Create or join a trip.")
                            .font(.headline)
                            .padding(.bottom, 16)
                        NavigationLink(destination: MapView(), isActive: $navigateToMapView) {
                            Button(action: {
                                navigateToMapView = true
                            }) {
                                Text("Go to Map")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            if !viewModel.passengerTrips.isEmpty {
                                Text("Passenger Trips")
                                    .font(.headline)
                                    .padding(.top)

                                ForEach(viewModel.passengerTrips.sorted(by: { $0.start_time > $1.start_time }), id: \.id) { trip in
                                    TripCardView(trip: trip)
                                }
                            }

                            if !viewModel.driverTrips.isEmpty {
                                Text("Driver Trips")
                                    .font(.headline)
                                    .padding(.top)

                                ForEach(viewModel.driverTrips.sorted(by: { $0.start_time > $1.start_time }), id: \.id) { trip in
                                    TripCardView(trip: trip)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onAppear {
                viewModel.fetchActiveTripsForCurrentUser()
            }
            .navigationTitle("Active Trips")
        }
    }
}

