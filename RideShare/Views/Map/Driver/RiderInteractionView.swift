//
//  RiderInteractionview.swift
//  RideShare
//
//  Created by Pablo Junco on 6/05/24.
//

import Foundation
import SwiftUI

struct RiderInteractionView: View {
    @Binding var mapState: MapViewState
    // Current rider-specific components

    var body: some View {
        VStack {
//            Text("Rider-specific interface")
            if mapState == .payment {
                PaymentView()
            }
            if mapState == .rideOffers {
                RidePickerView(mapState: $mapState)
            }
            // Add other rider-specific components
        }
    }
}
