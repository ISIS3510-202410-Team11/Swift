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
    
    var body: some View {
        ZStack(alignment:.bottom) {
            ZStack(alignment: .top){
                
                MapRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
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
                                    print("NO INTERNET")
                                    showAlert =  true
                                } else{
                                    showAlert = false
                                    mapState = .searchingForLocation
                                }
                                
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("No hay conexión a internet"),
                                message: Text("Por favor, verifica tu conexión e intenta nuevamente."),
                                dismissButton: .default(Text("Aceptar"))
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

#Preview {
    MapView()
}
