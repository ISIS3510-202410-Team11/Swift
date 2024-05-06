//
//  RideRequestView.swift
//  RideShare
//
//  Created by Cristian Caro on 15/04/24.
//

import SwiftUI

struct RideRequestView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    
    var body: some View {
        VStack{
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            //trip info
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.red))
                        .frame(width: 8, height: 8)
                    Rectangle()
                        .fill(Color(.black))
                        .frame(width: 1, height: 32)
                    Rectangle()
                        .fill(Color(.green))
                        .frame(width: 8, height: 8)
                }
                VStack(alignment:.leading, spacing: 24){
                    HStack{
                        Text("Current Location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(locationViewModel.pickUpTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    HStack{
                        
                        if let location = locationViewModel.selectedLocation{
                            Text(location.title)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        Spacer()
                        Text(locationViewModel.dropOffTime ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.leading, 8)
            }
            .padding()
            Divider()
                .padding(.vertical,6)
            
            
            //request ride button
            
            Button{
                ClickCounter.shared.incrementCount()
                withAnimation(.spring()){
                    actionState(mapState)
                }
            } label:{
                Text("Confirm Ride")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom,100)
        .background(.white)
        .cornerRadius(18)
    }
    func actionState(_ state: MapViewState){
        if state == .polylineaddded{
            mapState = .rideOffers
            if SessionManager.shared.isDriver{
                mapState = .createRide
            }
            
        }
    }
}
    
struct RideRequestView_Previews: PreviewProvider{
    static var previews: some View{
        RideRequestView(mapState: .constant(.polylineaddded))
    }
}
