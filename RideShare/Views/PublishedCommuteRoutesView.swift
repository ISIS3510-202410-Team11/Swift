//
//  PublishedCommuteRoutesView.swift
//  RideShare
//
//  Created by Pablo Junco on 29/05/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct PublishedCommuteRoutesView: View {
    @StateObject private var viewModel = BicycleRidesViewModel()

    var body: some View {
        List(viewModel.bicycleRides) { ride in
            HStack {
                Image(systemName: "bicycle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 8)
                    .foregroundColor(.green)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Start Location: \(ride.startLocation)")
                        .font(.subheadline)
                        .padding(.leading, 8)
                    Text("Start Time: \(ride.startTime)")
                        .font(.subheadline)
                        .padding(.leading, 8)
                    Text("End Location: \(ride.endLocation)")
                        .font(.subheadline)
                        .padding(.leading, 8)

                    HStack(spacing: 4) {
                        ForEach(ride.passengers, id: \.self) { _ in
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 8)
                }

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 4)
        }
        .navigationTitle("Bicycle Rides")
        .onAppear {
            viewModel.fetchBicycleRides()
        }
    }
}

//struct PublishedCommuteRoutesView_Previews: PreviewProvider {
//    static var previews: some View {
//        PublishedCommuteRoutesView()
//    }
//}
