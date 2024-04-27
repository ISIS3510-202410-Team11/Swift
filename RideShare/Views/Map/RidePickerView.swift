//
//  RidePickerView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct RidePickerView: View {
    let drivers = driverslist
    @Binding var mapState: MapViewState
    
    var body: some View {
        //NavigationStack{
        VStack{
            Text("Choose your prefered ride")
                .fontWeight(.bold)
                .foregroundColor(.black)
            Divider()
            ScrollView{
                LazyVStack{
                    ForEach(0 ... 10, id:\.self){ cell in
                        RidePickerCell()
                    }
                }
            }
            .refreshable {
                print("DEBUG: refresh")
            }
        }
        //}
        //.navigationTitle("Available Rides")
        //.navigationBarTitleDisplayMode(.inline)
        

    }
    func actionState(_ state: MapViewState){
        if state == .rideOffers{
            mapState = .payment
        }
    }
    
}

#Preview {
    RidePickerView(mapState: .constant(.rideOffers))
    
}
