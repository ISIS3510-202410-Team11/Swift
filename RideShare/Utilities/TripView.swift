//
//  SwiftUIView.swift
//  RideShare
//
//  Created by Juan Sebastian Pedraza Perez on 22/04/24.
//

import SwiftUI

struct RowView: View {
    var trip: Ended_Trips
    
    var body: some View {
        HStack {
            Spacer()

            
            trip.Image
                .resizable()
                .frame(width: 40, height: 40)
                .padding(.trailing, 8)
                
            
            VStack(alignment: .leading, spacing: 4) {
                Text(trip.driverUID)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Text(trip.initialAddress)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                Text(trip.finalAddress)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(Color.green.opacity(0.2))
        .cornerRadius(8)
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(trip: Ended_Trips(driverUID: "Hola", startHour:"9:20", initialAddress: "Calle 6a #88d-60", finalAddress: "Universidad de los andes", Image: Image(systemName: "person.fill")))
    }
}
