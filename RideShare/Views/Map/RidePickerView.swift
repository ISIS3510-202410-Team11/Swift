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
        VStack{
            Text("Choose your prefered ride")
                .fontWeight(.bold)
                .foregroundColor(.black)
            Divider()
            ScrollView{
                LazyVStack{
                    ForEach(0 ... 10, id:\.self){ cell in
                        RidePickerCell()
                            .onTapGesture {
                                actionState(mapState)
                            }
                    }
                }
            }
            .refreshable {
                print("DEBUG: refresh")
            }
        }
        .background(Color.white)

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
