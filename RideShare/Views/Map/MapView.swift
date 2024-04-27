//
//  MapView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct MapView: View {
    @State private var mapState = MapViewState.noInput
    // aaa @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
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
                                mapState = .searchingForLocation
                            }
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
