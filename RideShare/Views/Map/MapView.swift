//
//  MapView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct MapView: View {
    @State private var mapState = MapViewState.noInput
    @State private var showAlert = false
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var viewModel: LocationSearchViewModel = LocationSearchViewModel()
    @ObservedObject private var sessionManager = SessionManager.shared

    
    var body: some View {
        ZStack(alignment:.bottom) {
            ZStack(alignment: .top){
                
                MapRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                RideInteractionView(isDriver: sessionManager.isDriver)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                //new
                if mapState == .payment{
                    PaymentView()
                }
                //new
                if mapState == .rideOffers{
                    RidePickerView(mapState: $mapState)
                }

                
                if mapState == .searchingForLocation{
                    LocationSearchView(mapState: $mapState)
                }else if mapState == .noInput{
                    SearchBarView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()){
                                if !networkManager.isConnected{
                                    //print("DEBUG: NO INTERNET")
                                    showAlert =  true
                                } else{
                                    showAlert = false
                                    mapState = .searchingForLocation
                                }
                                
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("There is not connection to internet"),
                                message: Text("Please check your connection and try again later."),
                                dismissButton: .default(Text("Accept"))
                            )
                        }
                }
                OptionsButtonView(mapState: $mapState)
                    .padding(.leading)
                    .padding(.top,4)
                
            }
            if mapState == .locationSelected || mapState == .polylineaddded{
                RideRequestView(mapState: $mapState)
                    .transition(.move(edge: .bottom))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct RideInteractionView: View {
    
    var isDriver: Bool  // Boolean indicating if the user is a driver

    var body: some View {
        if isDriver {
            DriverView()
        } else {
            RiderView()
        }
    }

    private func RiderView() -> some View {
        VStack {
            // Components related to reservation and payment for riders
            Text("Book your ride")
            // Other UI components...
        }
    }

    private func DriverView() -> some View {
        VStack {
            // Components related to creating a ride for drivers
            Text("Create a new ride")
            // Other UI components...
        }
    }
}

#Preview {
    MapView()
}
