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
            trip.Image
                .resizable()
                .frame(width: 40, height: 40)

            VStack(alignment: .leading) {
                Text(trip.driverUID)
                Text(trip.initialAddress)
                Text(trip.finalAddress)
            }
            
            Spacer()
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(trip: Ended_Trips(driverUID: "Hola", startHour:"9:20", initialAddress: "Calle 6a #88d-60", finalAddress: "Universidad de los andes", Image: Image(systemName: "person.fill")))
    }
}

