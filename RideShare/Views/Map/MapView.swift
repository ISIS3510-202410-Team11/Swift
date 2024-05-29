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
    @State private var rideId: String = ""
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var viewModel: LocationSearchViewModel = LocationSearchViewModel()
    @ObservedObject private var sessionManager = SessionManager.shared

    var body: some View {
        ZStack(alignment:.bottom) {
            ZStack(alignment: .top){
                
                MapRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if SessionManager.shared.isDriver {
                    DriverInteractionView(mapState: $mapState, rideId: $rideId)
                } else {
                    RiderInteractionView(mapState: $mapState)
                }
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

//extension RideStatusViewModel {
//    static var sample: RideStatusViewModel {
//        let viewModel = RideStatusViewModel()
//        viewModel.destination = "Office"
//        viewModel.passengers = ["Alice", "Bob", "Charlie", "David"]
//        return viewModel
//    }
//}
//
//struct RideStatusView_Previews: PreviewProvider {
//    static var previews: some View {
//        RideStatusView(
//            rideStatusViewModel: .sample,
//            rideId: "example_ride_id"
//        )
//        .environmentObject(CreateRideViewModel()) // Provide a sample CreateRideViewModel
//        .environmentObject(LocationSearchViewModel()) // Provide a sample LocationSearchViewModel
//    }
//}
