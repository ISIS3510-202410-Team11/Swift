//
//  OptionsButtonView.swift
//  RideShare
//
//  Created by Cristian Caro on 22/03/24.
//

import SwiftUI

struct OptionsButtonView: View {
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel

    var body: some View {
        Button{
            AnalyticsManager.shared.logEvent(name: "UserNavigatesBackwards", params: ["OptionsButtonView":"Circular Button"])
            AnalyticsManager.shared.logEvent(name: "BQ2_0", params: ["OptionsButtonView":"Go back to the lastest view"])
            //removed in future
            ClickCounter.shared.incrementCount()
            withAnimation(.spring()){
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.green)
                .padding()
                .background(.white)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
    }
    func actionForState(_ state: MapViewState){
        switch state{
        case .noInput:
            print("No input")
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected, .polylineaddded:
            //solve bug of keeping a past location
            mapState = .noInput
            viewModel.selectedLocation = nil
        case .rideOffers:
            mapState = .polylineaddded
        case .payment:
            mapState = .rideOffers
        case .createRide:
                    mapState = .polylineaddded
        }
    }
    func imageNameForState(_ state: MapViewState)-> String{
        switch state{
        case .noInput:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .polylineaddded:
            return "arrow.left"
        case .rideOffers, .payment:
            return "arrow.left"
        case .createRide:
                    return "arrow.left"
        }
    }
}

#Preview {
    OptionsButtonView(mapState: .constant(.noInput))
}
