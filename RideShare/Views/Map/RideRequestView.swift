//
//  RideRequestView.swift
//  RideShare
//
//  Created by Cristian Caro on 15/04/24.
//

import SwiftUI

struct RideRequestView: View {
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
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    Rectangle()
                        .fill(.black)
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
            
            //Divider()
            //ride selection
            /*
            Text("Sugested rides")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(Color(.gray))
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal){
                HStack(spacing:12){
                    ForEach(0 ..< 3, id: \.self){_ in
                        VStack(alignment:.leading){
                            Image(systemName: "car")
                                .resizable()
                                .scaledToFit()
                            VStack(spacing: 4){
                                Text("Uber x")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Price")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding(8)
                        }
                        .frame(width: 112, height: 140)
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(10)
                    }
                }
            }
             */
            Divider()
                .padding(.vertical,6)
            //payment
            /*
            HStack(spacing: 12){
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                    .padding(.leading)
                Text("**** 1234")
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
            }
            .frame(height: 50)
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding(.horizontal)
             */
            //request ride button
            Button{
            } label:{
                Text("Confirm Ride")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom,16)
        .background(.white)
        .cornerRadius(18)
    }
}
    
struct RideRequestView_Previews: PreviewProvider{
    static var previews: some View{
        RideRequestView()
    }
}
