//
//  DriverInteractionView.swift
//  RideShare
//
//  Created by Pablo Junco on 6/05/24.
//

import Foundation
import SwiftUI

struct DriverInteractionView: View {
    @Binding var mapState: MapViewState
    // Additional driver-specific state and functions

    var body: some View {
        // Implement driver-specific components, e.g., accepting rides, managing routes
//        Text("Driver-specific interface")
        if mapState == .createRide {
            CreateRideView(mapState: $mapState, viewModel: LocationSearchViewModel())
        }
    }
}
