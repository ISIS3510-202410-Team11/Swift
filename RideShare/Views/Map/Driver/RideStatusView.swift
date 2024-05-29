//
//  RideStatusView.swift
//  RideShare
//
//  Created by Pablo Junco on 28/05/24.
//

import Foundation
import SwiftUI

struct RideStatusView: View {
    
    @ObservedObject var rideStatusViewModel = RideStatusViewModel()
    @EnvironmentObject var createRideViewModel: CreateRideViewModel
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var rideId: String
    
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
                        Text(createRideViewModel.startLocation)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(dateToString(createRideViewModel.departureTime))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                    HStack{
                        
                        Text(rideStatusViewModel.destination)
                            .font(.system(size: 16, weight: .semibold))
                            .onAppear {
                                if let location = viewModel.selectedLocation {
                                    rideStatusViewModel.updatedLocation(location.title)
                                }
                            }
                    }
                }
                .padding(.leading, 8)
            }
            .padding()
            Divider()
                .padding(.vertical,6)
            VStack(alignment: .leading) {
                Text("Passengers:")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                ForEach(rideStatusViewModel.passengers.prefix(4)) { passenger in
                    Text(passenger.name) // Display passenger name only
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            
            
        }
        .padding(.bottom,000)
        .background(.white)
        .cornerRadius(18)
        .onAppear {
            rideStatusViewModel.listenForPassengersUpdates(rideId: rideId)
        }
        .padding(.top,420)
    }
    func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Customize the date format as needed
        return formatter.string(from: date)
    }
}
struct RideStatusView_Previews: PreviewProvider {
    static var previews: some View {
        RideStatusView(rideId: "sampleRideId")
            .environmentObject(CreateRideViewModel())
            .environmentObject(LocationSearchViewModel())
    }
}
