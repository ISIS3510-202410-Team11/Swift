//
//  RidePickerCell.swift
//  RideShare
//
//  Created by Cristian Caro on 24/04/24.
//

import SwiftUI

struct RidePickerCell: View {
    var trip: ActiveTrips
    var index: Int

    var body: some View {
        VStack {
            HStack{
                Image(systemName: "car")
                    .resizable()
                    .foregroundColor(.black)
                    .accentColor(.white)
                    .frame(width: 40, height: 40)
                VStack{
                    Text(trip.end_location)//Placa
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Text("from: \(trip.start_location)")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                    Text(trip.start_time)
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                .padding(.leading, 8)
                .padding(.vertical, 8)
                
                Spacer()
                
                Text("$\(trip.estimated_fare)")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .padding()
                Image(systemName: "arrow.right")
                    .foregroundColor(.black)
                    .padding()
            }
            .padding(.leading)
        }
        Divider()
    }
}

#Preview {
    RidePickerCell(trip: ActiveTrips(id:"edwe", estimated_fare: "4000",driver_id: "defult", end_location: "location", passengers: ["p1","p2"], route: ["1,2,3"], start_location: "", start_time: "10:00"), index:0)
}
